require_relative './associatable'
require_relative './db_connection' # use DBConnection.execute freely here.
require_relative './mass_object'
require_relative './searchable'
require 'debugger'


class SQLObject < MassObject
  # sets the table_name
  def self.set_table_name(table_name)
    @table_name = table_name
  end

  # gets the table_name
  def self.table_name
    @table_name
  end

  # querys database for all records for this type. (result is array of hashes)
  # converts resulting array of hashes to an array of objects by calling ::new
  # for each row in the result. (might want to call #to_sym on keys)
  def self.all
    table_array = DBConnection.execute(<<-SQL)
      SELECT
        *
      FROM 
        "#{@table_name}"
    SQL
    table_array.map do |h|
      self.new(h)
    end
    
  end

  # querys database for record of this type with id passed.
  # returns either a single object or nil.
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

  # executes query that creates record in db with objects attribute values.
  # use send and map to get instance values.
  # after, update the id attribute with the helper method from db_connection
  def create
    attr_count = self.class.attributes.count
    question_mark_string = (['?'] * attr_count).join(", ")
    attr_vals = self.class.attributes.map { |attr| self.send(attr) }

    DBConnection.execute(<<-SQL, *attr_vals)
      INSERT INTO
        "#{self.class.table_name}" (#{self.class.attributes.join(", ")})
      VALUES
        (#{question_mark_string})

    SQL

    self.id = DBConnection.last_insert_row_id
  end

  # executes query that updates the row in the db corresponding to this instance
  # of the class. use "#{attr_name} = ?" and join with ', ' for set string.
  def update
    attr_vals = self.class.attributes.map { |attr| self.send(attr) }
    attr_string_parts = self.class.attributes.map { |attr| "#{attr} = ?" } 
    set_lines = attr_string_parts.join(", ")

    DBConnection.execute(<<-SQL, *attr_vals)
      UPDATE
        "#{self.class.table_name}"
      SET
        (set_lines)
      WHERE
        self.id = id

    SQL
  end

  # call either create or update depending if id is nil.
  def save
    self.nil? ? self.create : self.update
  end

  # helper method to return values of the attributes.
  def attribute_values
  end
end
