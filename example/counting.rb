#!/bin/sh ruby
# -*- encoding: utf-8 -*-

###
### ### Counting issues and accounts in the db
### Kazuki Hamasaki (ashphy@ashphy.com)
### 

require 'rubygems'
require 'active_record'

require_relative '../rietveld_models'
require_relative 'db_load'

puts "Number of issue is %d" % Issue.count
puts "Number of account is %d" % Account.count
