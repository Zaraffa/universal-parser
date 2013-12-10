module ResultModule
  
  @@dir = nil  
  @@rate = 10
  @@targets = %w[Parser]
  
  def self.targets
    @@targets
  end
  
  def self.rate
    @@rate
  end
  
  def self.dir
    @@dir
  end
  
  def self.dir= val
    @@dir = val
  end
  
  def self.post_parse *args
    # nil if !@dir
    # Dir[@dir].each do |file|
      # next if file[0]=='.'
      # p file 
    # end
    p args
  end
end