class AppConfig
  attr_accessor :object
    
  def initialize(path)    
    @config_path = path
    parse_config    
  end
      
  def parse_config
    @object = YAML::load(open(@config_path))      
  end
  
  private:parse_config
end