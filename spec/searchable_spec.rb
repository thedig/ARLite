require 'active_record_lite'

describe "searchable" do
  before(:all) do
<<<<<<< HEAD
    cats_db_file_name =File.expand_path(File.join(File.dirname(__FILE__), "cats.db"))
=======
    cats_db_file_name =
      File.expand_path(File.join(File.dirname(__FILE__), "../spec/cats.db"))
>>>>>>> skeleton
    DBConnection.open(cats_db_file_name)

    class Cat < SQLObject
      set_table_name("cats")
      my_attr_accessible(:id, :name, :owner_id)
<<<<<<< HEAD
=======
      my_attr_accessor(:id, :name, :owner_id)
>>>>>>> skeleton
    end

    class Human < SQLObject
      set_table_name("humans")
      my_attr_accessible(:id, :fname, :lname, :house_id)
<<<<<<< HEAD
=======
      my_attr_accessor(:id, :fname, :lname, :house_id)
>>>>>>> skeleton
    end
  end

  describe "#where" do
<<<<<<< HEAD
    it "returns correct cat" do
=======
    it "returns correct object given a single search term" do
>>>>>>> skeleton
      cat = Cat.where(:name => "Breakfast")[0]
      cat.name.should == "Breakfast"
    end

<<<<<<< HEAD
    it "returns correct human" do
=======
    it "returns correct object given multiple search terms (Testing AND in WHERE clause.)" do
>>>>>>> skeleton
      human = Human.where(:fname => "Matt", :house_id => 1)[0]
      human.fname.should == "Matt"
    end
  end
<<<<<<< HEAD
end
=======
end
>>>>>>> skeleton
