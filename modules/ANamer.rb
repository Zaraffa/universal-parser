# encoding: utf-8
module ANamer
  @@rate = 96
  @@targets = %w[Parser]  
  
  def self.targets
    @@targets
  end
  
  def self.rate
    @@rate
  end
  
  def self.each_parse *args        
    Parser::current_hash['b_name'] = ''
    res = Parser::current_hash['phone'].scan(/[А-Я]+[а-я]+/)
    Parser::current_hash['b_name'] = res.join(' ') unless res.empty?
  end    
end