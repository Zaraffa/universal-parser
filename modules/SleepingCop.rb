module SleepingCop
  
  @@rate = 2
  @@targets = %w[Parser]
  
  def self.targets
    @@targets
  end
  
  def self.rate
    @@rate
  end
  
  def self.each_parse *args               
    sleep Parser::config['Interval'] if Parser::config['SleepingCop'] && Parser::current_src==:http       
  end
  
end