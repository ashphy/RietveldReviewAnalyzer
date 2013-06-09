# -*- encoding: utf-8 -*-

###
### Rietveld Review Data DB Models
### Kazuki Hamasaki (ashphy@ashphy.com)
### 

require 'rubygems'
require 'active_record'


class Issue < ActiveRecord::Base
  attr_accessible :id, :description, :private, :closed
  attr_accessible :commit, :base_url, :subject, :created
  attr_accessible :modified, :owner
  
  has_many :issue_ccs
  has_many :ccs, :through => :issue_ccs, :source => :account
  
  has_many :issue_reviewers
  has_many :reviewers, :through => :issue_reviewers, :source => :account
  
  has_many :patchsets
  belongs_to :owner, :class_name => 'Account', :foreign_key => 'owner_id'
  
  has_many :messages
end

class Message < ActiveRecord::Base
  belongs_to :sender, :class_name => 'Account', :foreign_key => 'sender_id'

  belongs_to :issue
  
  has_many :message_recipients
  has_many :recipients, :through => :message_recipients, :source => :account
end

class Account < ActiveRecord::Base
  has_many :issue_ccs
  has_many :received_ccs, :through => :issue_ccs, :source => :issue
  
  has_many :issue_reviewers
  has_many :review_issues, :through => :issue_reviewers, :source => :issue
  
  has_many :message_recipients
  has_many :messages, :through => :message_recipients, :source => :message
end

class Patchset < ActiveRecord::Base
  belongs_to :issue
end

# Intervening models
class IssueReviewer < ActiveRecord::Base
  belongs_to :issue
  belongs_to :account
end

class MessageRecipient < ActiveRecord::Base
  belongs_to :message
  belongs_to :account
end

class IssueCc < ActiveRecord::Base
  belongs_to :issue
  belongs_to :account
end