require "has_logs/version"
require 'active_support'
require 'active_record'
require 'has_logs/has_logs'
require 'has_logs/act_as_log'

module HasLogs
end

ActiveRecord::Base.include HasLogs::HasLogs
ActiveRecord::Base.include HasLogs::ActAsLog
