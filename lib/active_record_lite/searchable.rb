require_relative './db_connection'

module Searchable
  # takes a hash like { :attr_name => :search_val1, :attr_name2 => :search_val2 }
  # map the keys of params to an array of  "#{key} = ?" to go in WHERE clause.
  # Hash#values will be helpful here.
  # returns an array of objects
  def where(params)
  	param_strings = []
  	values_arr = []
  	params.each do |key, val|
  		param_strings << "#{key} = ?"
  		values_arr << val
  	end

  	query_string = <<-SQL
  		SELECT
  			*
			FROM
				#{self.table_name}
  		WHERE
  			#{param_strings.join(" AND ")}
  	SQL

  	puts query_string

  	self.parse_all(DBConnection.execute(query_string, *values_arr))
  # 	hash_array = DBConnection.execute(query_string, *values_arr)

		# hash_array.map do |h|
  #     self.new(h)
  #   end
  end
end