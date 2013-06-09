#!/bin/sh ruby
# -*- encoding: utf-8 -*-

###
### Rietveld Review Data Import Tool to Mysql
### Kazuki Hamasaki (ashphy@ashphy.com)
### 

require 'rubygems'
require 'active_record'
require 'json'
require 'logger'

require_relative 'rietveld_models'

class Importer
  
  def initialize()
    db_config = YAML.load_file('database.yml').symbolize_keys
    setting_name = db_config[:setting]
    ActiveRecord::Base.establish_connection(db_config[:"#{setting_name}"])
  end
  
  # Get account from email address. 
  # If not exists, create new one.
  def getAccount(email, name=nil)
    account = Account.find_by_email(email)
    if account
      if account.name && name
        account.update_attributes!(:name => name)
      end
    else
      account = Account.new(:name => name, :email => email)
    end
    
    account
  end
  
  #
  # Parse json to create new record
  #
  def parse(line)
    json = JSON.parse(line)
    $stderr.print " at issue #%s :" % json["issue"]

    #Issue    
    issue = Issue.find_or_create_by_id(
      :id          => json["issue"].to_i,
      :description => json["description"],
      :private     => json["private"],
      :closed      => json["closed"],
      :commit      => json["commit"],
      :base_url    => json["base_url"],
      :subject     => json["subject"],
      :created     => json["created"],
      :modified    => json["modified"],
      :owner       => self.getAccount(json["owner_email"], json["owner"])
    )
    
    for reviewer_email in json["reviewers"]
      issue.reviewers << self.getAccount(reviewer_email) 
    end
      
    for cc_email in json["cc"]
      issue.ccs << self.getAccount(cc_email) 
    end
      
    for patchset_id in json["patchsets"]
      issue.patchsets.create(:patchset_id => patchset_id)
    end
    
    #Message  
    for json_mes in json["messages"]
      message = Message.new(
        :sender       => self.getAccount(json_mes["sender"]),
        :text         => json_mes["text"],
        :disapproval  => json_mes["disapproval"],
        :date         => json_mes["date"],
        :approval     => json_mes["approval"]
      )
        
      for recipient_email in json_mes["recipients"]
        message.recipients << self.getAccount(recipient_email)
      end
        
      issue.messages << message
    end
  end
  
  def import(file)
    import_file = open(file, "r:utf-8") { |f|
      size = File.size f.path
      while line = f.gets
        #Show progress
        $stderr.print " Importing review data %.3f%% (%s/%s)" % ([f.tell.to_f/size.to_f*100, f.tell, size])
        self.parse(line)
        $stderr.print("\r")
      end
    }  
  end
  
end

if __FILE__ == $0
  if ARGV.size == 0
    puts 'usage: ruby rietveld_import_to_mysql.rb file'
  else
    impoter = Importer.new
    impoter.import(ARGV[0])    
  end
end