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
<<<<<<< HEAD
  def initialize(name, params, self_class)
    @foreign_key = (params[:foreign_key] ||
      "#{self_class.name.underscore}_id".to_sym)
    @other_class_name = (params[:class_name] ||
      name.to_s.singularize.camelcase)
=======
  attr_reader :primary_key, :foreign_key, :class_name

  def initialize(name, params, self_class)
    @name = name
    @self_class = self_class
    @class_name = params[:class_name] || @name.to_s.singularize.capitalize
    @foreign_key = params[:foreign_key] || "#{@self_class.to_s.camelcase}_id".to_sym
>>>>>>> skeleton
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
<<<<<<< HEAD
    aps = HasManyAssocParams.new(name, params, self)
    assoc_params[name] = aps

    define_method(name) do
      results = DBConnection.execute(<<-SQL, self.send(aps.primary_key))
        SELECT *
          FROM #{aps.other_table}
         WHERE #{aps.other_table}.#{aps.foreign_key} = ?
=======
    options = HasManyAssocParams.new(name, params, self)
    define_method(options.name) do
      return_array = DBConnection.execute(<<-SQL)
        SELECT
          *
        FROM
          #{options.table_name}
        WHERE
          #{options.foreign_key.to_s} = #{self.send(options.primary_key.to_s.downcase)}
>>>>>>> skeleton
      SQL

      return_array.map { |hash| options.model_class.new(hash) }
    end
  end

  def has_one_through(name, assoc1, assoc2)
<<<<<<< HEAD
    define_method(name) do
      params1 = self.class.assoc_params[assoc1]
      params2 = params1.other_class.assoc_params[assoc2]

      pk1 = self.send(params1.foreign_key)
      results = DBConnection.execute(<<-SQL, pk1)
          SELECT #{params2.other_table}.*
          FROM #{params1.other_table}
          JOIN #{params2.other_table}
            ON #{params1.other_table}.#{params2.foreign_key}
                 = #{params2.other_table}.#{params2.primary_key}
         WHERE #{params1.other_table}.#{params1.primary_key}
                 = ?
      SQL

      params2.other_class.parse_all(results).first
=======
    define_method(name.to_sym) do
      intermediary = self.send(assoc1)
      intermediary.send(assoc2)
>>>>>>> skeleton
    end
  end
end
