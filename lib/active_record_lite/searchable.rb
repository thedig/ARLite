require_relative './db_connection'

module Searchable

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

  	self.parse_all(DBConnection.execute(query_string, *values_arr))

  end
end