module HasLogs
  module ActAsLog
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def act_as_log_of(class_name = nil, options = {})
        act_as_log(options.merge(class_name: class_name))
      end

      def act_as_log(options = {})
        return if self.included_modules.include?(ActAsLog::InstanceMethods)
        include ActAsLog::InstanceMethods

        cattr_accessor :originator_class_name

        self.originator_class_name = options[:class_name] || (self.name.gsub /Log\Z/, '')

        class_eval do
          belongs_to :originator, options.merge(class_name: originator_class_name, foreign_key: "#{originator_class_name.underscore}_id", touch: true)

          validates :"#{originator_class_name.underscore}_id", presence: true, uniqueness: { scope: :created_at }
        end
      end

      def originator_class
        originator_class_name.constantize
      end
    end

    module InstanceMethods
      def next
        originator.logs.where("created_at > ?", self.created_at).order(:created_at).first
      end

      def prev
        originator.logs.where("created_at < ?", self.created_at).order(:created_at).last
      end
    end

  end
end
