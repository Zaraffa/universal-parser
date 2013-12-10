module Namer
  
  @@rate = 95
  @@targets = %w[Parser]
  @@mans = []
  @@womans = [] 
  
  def self.targets
    @@targets
  end
  
  def self.rate
    @@rate
  end
  
  def self.init        
    nil unless @@mans.empty? && @@womans.empty?   
    File.open("./data/mans.txt", "r") do |infile|      
      while (line = infile.gets)        
        @@mans.push line.strip
      end
    end
    File.open("./data/womans.txt", "r") do |infile|
      while (line = infile.gets)        
        @@womans.push line.strip
      end
    end
    
  end
  
  def self.each_parse *args      
    init    
    str = Parser::current_hash['title'] + Parser::current_hash['personal'] + Parser::current_hash['additional']
    str = str.force_encoding("BINARY")            
    @@mans.each { |name|        
      if str.include?(name.force_encoding("BINARY"))
        Parser::current_hash['a_name']= name;
        break
      end
    }             
    nil if Parser::current_hash['a_name']
    @@womans.each { |name|        
     if str.include?(name.force_encoding("BINARY"))
        Parser::current_hash['a_name']= name;
        break
      end
    }    
  end
  
end