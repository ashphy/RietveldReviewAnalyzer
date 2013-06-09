#!/bin/sh ruby
# -*- encoding: utf-8 -*-

###
### Exporting review data to CSV
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

puts "id,OwnerEmail,#Reviewers,#CCs,#Messages,#Patchsets,#Approves,isCommit?,isClosed?,Created,Modified,ReviewDuration (Days),Subject"
Issue.find_each() do |issue|
  issue_index += 1
  $stderr.print "\rFetch %d/%d\t" % [issue_index, total_issues]
  
  puts %Q{%d,"%s",%d,%d,%d,%d,%d,%s,%s,%s,%s,%s,"%s"} % [
    issue.id,
    issue.owner.email,
    issue.reviewers.size,
    issue.ccs.size,
    issue.messages.size,
    issue.patchsets.size,
    issue.messages.find_all_by_approval(true).size,
    issue.commit,
    issue.closed,
    issue.created,
    issue.modified,
    (issue.modified - issue.created).divmod(24*60*60)[0],
    issue.subject
  ]
end