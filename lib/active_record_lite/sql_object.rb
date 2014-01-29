require_relative './associatable'
require_relative './db_connection' # use DBConnection.execute freely here.
require_relative './mass_object'
require_relative './searchable'
require 'debugger'
require 'active_support/inflector'


class SQLObject < MassObject

  extend Searchable
  extend Associatable

  def self.set_table_name(table_name = self.to_s.camelcase.pluralize)
    @table_name = table_name
  end

  def self.table_name
    @table_name ||= self.set_table_name
  end

  def self.all
    table_array = DBConnection.execute(<<-SQL)
      SELECT
        "#{@table_name}".*
      FROM 
        "#{@table_name}"
    SQL

    self.parse_all(table_array)
  end

  def self.find(id)
    val = DBConnection.execute(<<-SQL, id).first
      SELECT
        *
      FROM
        "#{@table_name}"
      WHERE
        id = ?
    SQL
    return nil if val.nil?
    self.new(val)

  end

  def self.parse_all(hash_array)
    hash_array.map do |h|
      new_h = {}
      h.each { |k, v| new_h[k.to_sym] = v }
      self.new(new_h)
    end
  end

  def create
    attr_count = self.class.attributes.count
    question_mark_string = (['?'] * attr_count).join(", ")

    DBConnection.execute(<<-SQL, *attribute_values)
      INSERT INTO
        "#{self.class.table_name}" (#{self.class.attributes.join(", ")})
      VALUES
        (#{question_mark_string})
    SQL

    self.id = DBConnection.last_insert_row_id
  end

  def update
    attr_string_parts = self.class.attributes.map { |attr| "#{attr} = ?" } 
    set_lines = attr_string_parts.join(", ")

    DBConnection.execute(<<-SQL, *attribute_values)
      UPDATE
        #{self.class.table_name}
      SET
        #{set_lines}
      WHERE
        id = #{self.id}

    SQL

  end

  def save
    self.id.nil? ? self.create : self.update
  end

  def attribute_values
    self.class.attributes.map { |attr| self.send(attr) }
  end
end
