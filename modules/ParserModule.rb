require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'net/http'
require 'json'
require 'sanitize'
   
module ParserModule
  
  @@rate = 100
  @@targets = %w[Parser]
  
  def self.targets
    @@targets
  end
  def self.rate
    @@rate
  end

  def self.each_parse *args
    path = args.first.chomp
    id = eval Parser::config['id']
    cache = CacheMaster::filename(id)              
    if(File.exists?(cache.to_s) && CacheMaster::cache_to_date?(id))
      Parser::current_page = File.open(cache,'rb').read            
      Parser.current_src=:internal      
    else        
      Parser.current_src=:http
      Parser::current_page = open(path).read          
    end                  
      page = Nokogiri::HTML(Parser::current_page)
      dataRules = Parser.config['DataPathes']
      hash = {}
      grange = 0
      dataRules.each do |rule|
        if rule[1]['path'] && !rule[1]['system']
          if(rule[1]['allow_html'])
            hash[rule.first] = page.css(rule[1]['path']).inner_html.strip if rule[1]['path']            
            hash[rule.first] = Sanitize.clean(hash[rule.first], :elements => rule[1]['allowed_html'])
          else
            hash[rule.first] = page.css(rule[1]['path']).text.to_s.strip if rule[1]['path']
            hash[rule.first] = page.css(rule[1]['path']).map { |el| el[(rule[1]['attr'])] } if rule[1]['attr']
            hash[rule.first] = '' if hash[rule.first].empty?
            hash[rule.first] = hash[rule.first].first if hash[rule.first].kind_of?Array
          end
          grange+=rule[1]['range'] if hash[rule.first]                    
        elsif rule[1]['system']
          hash[rule.first] = eval(rule[1]['system']).strip                      
        end
        hash[rule.first].prepend(rule[1]['pref']) if(rule[1]['pref']) && !hash[rule.first].empty?      
      end             
    if grange>Parser::config['min_range']
      Parser::current_hash = hash
    else
      p "skip page "+path+" coz it haven't key elements"  
    end             
  end 
end