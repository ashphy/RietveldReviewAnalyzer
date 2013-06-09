#!/bin/sh ruby
# -*- encoding: utf-8 -*-

###
### Calculating summary of reviews
### Kazuki Hamasaki (ashphy@ashphy.com)
### 

require 'rubygems'
require 'active_record'

require_relative '../rietveld_models'
require_relative 'db_load'

total_issues = Issue.count

issue_index = 0
counter = {}
counter.default = 0

Issue.find_each() do |issue|
  issue_index += 1
  print "\rFetch %d/%d" % [issue_index, total_issues]
  
  counter[:reviewer]  += issue.reviewers.size
  counter[:cc]        += issue.ccs.size
  counter[:messages]  += issue.messages.size
  counter[:patchsets] += issue.patchsets.size
end

puts "\n Total %d issues" % total_issues
counter.each do |key, value|
  puts "Avg. of %s that the issues have is %f" % [key, value / total_issues.to_f]
end