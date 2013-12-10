require_relative 'Hooks'
require_relative './modules/ParserModule'
require_relative './modules/ResultModule'
require_relative './modules/ProgressModule'
require_relative './modules/JapaneeseModule'
require_relative './modules/CustomFilter'
require_relative './modules/StorageModule'
require_relative './modules/SleepingCop'
require_relative './modules/CacheMaster'
require_relative './modules/ANamer'

class Parser

  @@hooks = %w[pre_parse each_parse post_parse post_each_parse]  
  @@current_page = nil
  @@current_hash = nil
  @@current_src = :http
       
  def initialize(config)    
    @@config = config
    performSitemap    
  end  
  
  #accessors
  def self.config
    @@config if defined? @@config
  end
  
  def self.hooks
    @@hooks if defined? @@hooks
  end    
  
  def self.current_page= page
    @@page = page
  end    
  
  def self.current_page
    @@page
  end    
  
  def self.current_hash
    @@current_hash
  end
  
  def self.current_hash= hash
    @@current_hash = hash
  end
  
  def self.current_src= source
    @@current_src = source
  end    
  
  def self.current_src
    @@current_src
  end    
  
  #hooks
  def pre_parse *args
    
  end

  def post_parse *args
    
  end
  
  def each_parse *args
    
  end
  
  def post_each_parse *args
    
  end
    
    
  def performSitemap  
    #before sitemap  
    url = @@config['Host']+@@config['SiteMap'] if @@config['SiteMap']    
    sitemap = Sitemap.new(url)
    sitemap.toFile rescue nil    
    #after sitemap     
  end
  
  def parse
    false if !File.exist?Sitemap::filename
    @count = 0
    File.open(Sitemap::filename) {|f| @count = f.read.count("\n")}
    #pre_parse    
    pre_parse @count         
    File.new(Sitemap::filename).each do |line|             
        each_parse line rescue nil
        post_each_parse line rescue nil
    end
    #post_parse
    post_parse 'test'
  end
  
  include Hooks
end