module Validation
  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
  end

  module ClassMethods
    def validate(name_atr, type_valid, extention = nil)
      @parameters ||= []
      @parameters << { name_atr => { type_validation: type_valid, ext: extention } }
    end
  end

  module InstanceMethods
    def valid?
      validate!
      true
    rescue StandardError => e
      puts "ERROR!!! ==> #{e}"
      false
    end

    protected

    def validate!
      self.class.instance_variable_get(:@parameters).each do |parameter_line|
        parameter_line.each do |attr_name, data_valid|
          variable = instance_variable_get("@#{attr_name}")
          send(data_valid[:type_validation], variable, data_valid[:ext])
        end
      end
    end

    def presence(var, _extention)
      raise "PresenceError #{var}" if var.nil? || var.empty?
    end

    def format(var, extention)
      raise "FormatError #{var}..." unless var.to_s =~ extention
    end

    def type(var, extention)
      raise "TypeError #{var}..." unless var.is_a?(extention)
    end
  end
end
