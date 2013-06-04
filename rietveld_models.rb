# -*- encoding: utf-8 -*-

###
### Rietveld Review Data DB Models
### Kazuki Hamasaki (ashphy@ashphy.com)
### 

require 'rubygems'
require 'active_record'


class Issue < ActiveRecord::Base
  belongs_to :account, :class_name => 'Account', :foreign_key => 'owner_id'
end

class Account < ActiveRecord::Base
  has_many :issues
  accepts_nested_attributes_for :issues
end

class Cc < ActiveRecord::Base
end

class Reviewer < ActiveRecord::Base
end

class Patchset < ActiveRecord::Base
end

class Message < ActiveRecord::Base
end

class Recipient < ActiveRecord::Base
end

class Sender < ActiveRecord::Base
end