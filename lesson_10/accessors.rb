module Accessors
  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
  end

  module ClassMethods
    def attr_accessor_with_history(*attrs)
      vars = attrs.map { |atr| "@#{atr}".to_sym }
      instances = {}
      attrs.each_with_index do |atr, index|
        define_method(atr) { instance_variable_get(vars[index]) }

        define_method("#{atr}=".to_sym) do |value|
          instances[atr].nil? ? instances[atr] ||= [] : instances[atr] << instance_variable_get(vars[index])
          instance_variable_set(vars[index], value)
        end

        define_method("#{atr}_history") { instances[atr] }
      end
    end

    def strong_attr_accessor(atr, atr_class_type)
      instance_var = "@#{atr}".to_sym
      define_method(atr) { instance_variable_get(instance_var) }

      define_method("#{atr}=".to_sym) do |value|
        raise 'Error!!! Type Error!' unless value.is_a?(atr_class_type)

        instance_variable_set(instance_var, value)
      end
    end
  end

  module InstanceMethods
  end
end
