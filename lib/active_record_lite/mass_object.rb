class MassObject
  
  # takes a list of attributes.
  # adds attributes to whitelist.
  def self.my_attr_accessible(*attributes)     
    @attributes = []
    attributes.each do |attrib|
      @attributes << attrib
    end
    @attributes
  end

  # takes a list of attributes.
    # @attributes
  # makes getters and setters
  def self.my_attr_accessor(*attributes)
    attributes.each do |attrib|
      define_method("#{attrib}") do
        instance_variable_get("@#{attrib}")
      end

      define_method("#{attrib}=") do |a|
        instance_variable_set("@#{attrib}", a)
      end

    end
  end


  # returns list of attributes that have been whitelisted.
  def self.attributes
    if self.class == MassObject
      raise "Cannot call on MassObject"
    else
      @attributes
    end
  end

  # takes an array of hashes.
  # returns array of objects.
  def self.parse_all(results)
    results.map do |h|
      self.new(h)
    end
  end

  # takes a hash of { attr_name => attr_val }.
  # checks the whitelist.
  # if the key (attr_name) is in the whitelist, the value (attr_val)
  # is assigned to the instance variable.
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
