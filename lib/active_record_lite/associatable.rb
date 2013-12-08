require 'active_support/core_ext/object/try'
require 'active_support/inflector'
require_relative './db_connection.rb'

class AssocParams
  def other_class
    
  end

  def other_table
  end
end

class BelongsToAssocParams < AssocParams
  def initialize(name, params)
    @name = name
    expected_params = [:class_name, :foreign_key, :primary_key]
    expected_params.each do |expected|
      if params.keys.include?(expected)
        instance_variable_set("@#{expected.to_s}", params[expected])
      elsif expected == :primary_key
        instance_variable_set("@#{expected.to_s}", "id")
      elsif expected == :foreign_key
        instance_variable_set("@#{expected.to_s}", "foreign")
      elsif expected == :class_name
        instance_variable_set("@#{expected.to_s}", @name.classify)
      end
    end

  end

  def type
  end
end

class HasManyAssocParams < AssocParams
  def initialize(name, params, self_class)
  end

  def type
  end
end

module Associatable
  def assoc_params
  end

  def belongs_to(name, params = {})
  end

  def has_many(name, params = {})
  end

  def has_one_through(name, assoc1, assoc2)
  end
end
