#!/bin/sh ruby
# -*- encoding: utf-8 -*-

###
### Rietveld Review Data Import Tool to Mysql
### Kazuki Hamasaki (ashphy@ashphy.com)
### 

require 'rubygems'
require 'active_record'
require 'json'

require_relative 'rietveld_models'

class Importer
  
  def initialize()
     ActiveRecord::Base.establish_connection(
      :adapter  => 'mysql',
      :host     => '127.0.0.1',
      :username => 'root',
      :password => '',
      :database => 'Rietveld'
    )
  end
  
  def import(file)
    import_file = open(file, "r:utf-8") { |f|
      while line = f.gets
        json = JSON.parse(line)
        issue = Issue.new
        issue.id          = json["issue"].to_i
        issue.description = json["description"]
        issue.private     = json["private"]
        issue.closed      = json["closed"]
        issue.commit      = json["commit"]
        issue.base_url    = json["base_url"]
        issue.subject     = json["subject"]
        issue.created     = json["created"]
        issue.modified    = json["modified"]
        issue.account     = issue.create_account(:name => json["owner"], :email => json["owner_email"])        
        issue.save!
      end
    }  
  end
  
end

if __FILE__ == $0
  impoter = Importer.new
  impoter.import(ARGV[0])
end