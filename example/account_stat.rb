#!/bin/sh ruby
# -*- encoding: utf-8 -*-

###
### Show account statuses
### Kazuki Hamasaki (ashphy@ashphy.com)
### 

require 'rubygems'
require 'active_record'

require_relative '../rietveld_models'
require_relative 'db_load'

puts "E-mail, Name, Received CCs, Reviews, Owners"
Account.find_each() do |account|
  puts %Q{"%s","%s",%d,%d,%d} % [
    account.email,
    account.name,
    account.received_ccs.count,
    account.review_issues.count,
    account.owner_issues.count
  ]
end