module HasLogs
  module HasLogs
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def has_logs_as(class_name = nil, options = {})
        has_logs(options.merge(class_name: class_name))
      end

      def has_logs(options = {})
        return if self.included_modules.include?(HasLogs::InstanceMethods)
        include HasLogs::InstanceMethods

        cattr_accessor :log_class_name, :log_foreign_key, :log_table_name, :logging_attrs

        self.log_class_name  = options[:class_name]  || "#{self.name}Log"
        self.log_foreign_key = options[:foreign_key] || "#{self.name}Id".underscore

        self.logging_attrs = (log_class.column_names - [log_class.primary_key, "#{self.name}Id".underscore, 'created_at'])

        class_eval do
          has_many :logs, options.merge(class_name: log_class_name, foreign_key: log_foreign_key)
          after_find   :set_attrs
          after_create :create_log
          after_update :create_log

          logging_attrs.each do |attr|
            attr_accessor attr
            define_method "#{attr}?" do
              public_send(:attr).present?
            end
          end
        end
      end

      def log_class
        log_class_name.constantize
      end
    end

    module InstanceMethods
      def latest_log
        logs.order(:created_at).last
      end

      def oldest_log
        logs.order(:created_at).first
      end

      def create_log
        values = {}
        self.class.logging_attrs.each do |attr|
          values[attr] = send(attr)
        end
        logs.build(values).save
      end

      def set_attrs
        self.class.logging_attrs.each do |attr|
          self.send("#{attr}=", latest_log.try(:"#{attr}"))
        end
      end
    end
  end
end
