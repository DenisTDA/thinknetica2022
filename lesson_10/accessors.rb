module Accessors
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def attr_accessor_with_history(*attrs)
      attrs.each do |attr_name|
        name_var = "@#{attr_name}".to_sym
        var_history = "@#{attr_name}_history".to_sym

        define_method(attr_name) { instance_variable_get(name_var) }
        define_method("#{attr_name}_history") { instance_variable_get(var_history) }

        define_method("#{attr_name}=".to_sym) do |value|
          if instance_variable_defined?(name_var)
            history = instance_variable_get(var_history)
            history ||= []
            history << instance_variable_get(name_var)
            instance_variable_set(var_history, history)
          end
          instance_variable_set(name_var, value)
        end
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
end
