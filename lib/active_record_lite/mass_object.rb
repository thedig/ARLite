class MassObject
<<<<<<< HEAD
  def self.my_attr_accessible(*attributes)
    # convert to array of symbols in case the user gives you strings.
    @attributes = attributes.map { |attr_name| attr_name.to_sym }
=======

  def self.my_attr_accessible(*attributes)     
    @attributes = []
    attributes.each do |attrib|
      @attributes << attrib
    end
    @attributes
  end

  def self.my_attr_accessor(*attributes)
    attributes.each do |attrib|
      define_method("#{attrib}") do
        instance_variable_get("@#{attrib}")
      end

      define_method("#{attrib}=") do |a|
        instance_variable_set("@#{attrib}", a)
      end
>>>>>>> skeleton

    end
  end

  def self.attributes
    if self.class == MassObject
      raise "Cannot call on MassObject"
    else
      @attributes ||= []
    end
  end

  def self.parse_all(results)
    results.map do |h|
      self.new(h)
    end
  end

  def initialize(params = {})
    params.each do |param, attr_val|
      param = param.to_sym
      unless self.class.attributes.include?(param)
        raise "mass assignment to unregistered attribute not_protected"
      end
      self.send("#{param}=", attr_val)
    end
  end
end
