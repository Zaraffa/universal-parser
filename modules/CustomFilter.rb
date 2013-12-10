module CustomFilter
  
  @@rate = 90
  @@targets = %w[Parser]
  
  def self.targets
    @@targets
  end
  
  def self.rate
    @@rate
  end
  
  def self.each_parse *args
    dataRules = Parser.config['DataPathes']    
    # hash[rule.first] = page.css(rule[1]['path']).text if rule[1]['path']       
    # Parser::current_hash.each do |hash|
      dataRules.each do |rule|
        if(rule[1]['drop'])
          rule[1]['drop'].split(',').each do |drop|                    
            Parser::current_hash[rule.first].delete!(drop)
            Parser::current_hash[rule.first].strip!
          end
        end  
        if(rule[1]['replace'])
          rule[1]['replace'].split(',').each do |replace|            
            target = replace.split('=').first
            replacement = replace.split('=').last                        
            replacement = '' if replacement.eql?'nothing'
            target = eval target if '/'.eql?target[0]                      
            while Parser::current_hash[rule.first].gsub!(target,replacement); end
            Parser::current_hash[rule.first].strip!
          end
        end
      # end
    end          
  end
  
end