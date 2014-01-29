
# Active Record Lite

This project contains the basics of Active Record functionality.  Metaprogramming is used in order to redefine common AR features:

- __attr_accessible__ and __attr_accessor__
- __Initial table setup__
- __Common SQL queries, such as:__
	* _Find by id_
	* _Find all_
	* _Update record_
	* _Create new record_
	* _Save_
- __BelongsTo and HasMany associations__
- __HasOneThrough__

SQL queries are written using Heredocs, leveraging string interpolation to handle a variable number of inputs into the queries. Methods and instance variables are setup through the use of ::send and ::define_method.