#!/bin/sh ruby
# -*- encoding: utf-8 -*-

###
### DB Setting Script
### Kazuki Hamasaki (ashphy@ashphy.com)
### 

require 'rubygems'
require 'active_record'

#Load DB Setting
db_config = YAML.load_file('../database.yml').symbolize_keys
setting_name = db_config[:setting]
ActiveRecord::Base.establish_connection(db_config[:"#{setting_name}"])