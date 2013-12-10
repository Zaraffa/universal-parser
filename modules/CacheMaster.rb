module CacheMaster

  @@rate = 1
  @@targets = %w[Parser Sitemap]
  
  def self.targets
    @@targets
  end
  
  def self.rate
    @@rate
  end
  
  def self.filename id
    Parser::config['CacheStorage']+Parser::config['ClientAlias']+"/"+id
  end
  
  def self.cache_to_date? id       
    (Time.now - File.ctime(filename(id)))<60*60*24*20
  end
  
  def self.post_each_parse path    
    nil if Parser::current_src == :internal    
    dir = Parser::config['CacheStorage']+Parser::config['ClientAlias']
    FileUtils.mkdir_p dir unless File.directory?dir    
    path = path.to_s       
    id = eval Parser::config['id']
                                  
    open(filename(id).to_s.strip, 'wb') do |f|       
      if f.puts Parser::current_page      
        p filename+" were written successfully"
      end
    end
    
    
  end
  
end