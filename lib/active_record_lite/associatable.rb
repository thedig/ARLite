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
  attr_reader :primary_key, :foreign_key, :class_name

  def initialize(name, params)
    @name = name
    @class_name = params[:class_name] || @name.to_s.singularize.capitalize
    @foreign_key = params[:foreign_key] || "#{@class_name.to_s.camelcase}_id".to_sym
    @primary_key = params[:primary_key] || :id
  end

  def model_class
    class_name.constantize
  end

  def name
    @name.to_sym
  end

  def table_name
    model_class.table_name
  end

  def type
  end
end

class HasManyAssocParams < AssocParams
  attr_reader :primary_key, :foreign_key, :class_name

  def initialize(name, params, self_class)
    @name = name
    @self_class = self_class
    @class_name = params[:class_name] || @name.to_s.singularize.capitalize
    @foreign_key = params[:foreign_key] || "#{@self_class.to_s.camelcase}_id".to_sym
    @primary_key = params[:primary_key] || :id
  end

  def model_class
    class_name.constantize
  end

  def name
    @name.to_sym
  end

  def table_name
    model_class.table_name
  end

  def type
  end
end

module Associatable
  def assoc_params
  end

  def belongs_to(name, params = {})
    options = BelongsToAssocParams.new(name, params)
    define_method(options.name) do
      return_val = DBConnection.execute(<<-SQL).first
        SELECT
          *
        FROM
          #{options.table_name}
        WHERE
          #{options.primary_key.to_s} = #{self.send(options.foreign_key.to_s.downcase)}
      SQL

      options.model_class.new(return_val)

    end
  end

  def has_many(name, params = {})
    options = HasManyAssocParams.new(name, params, self)
    define_method(options.name) do
      return_array = DBConnection.execute(<<-SQL)
        SELECT
          *
        FROM
          #{options.table_name}
        WHERE
          #{options.foreign_key.to_s} = #{self.send(options.primary_key.to_s.downcase)}
      SQL

      return_array.map { |hash| options.model_class.new(hash) }
    end
  end

  def has_one_through(name, assoc1, assoc2)
    define_method(name.to_sym) do
      intermediary = self.send(assoc1)
      intermediary.send(assoc2)
    end
  end
end
