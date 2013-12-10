require 'json'
module StorageModule
  
  @@rate = 90
  @@hashes = []
  @@targets = %w[Parser]
  
  def self.targets
    @@targets
  end
  
  def self.rate
    @@rate
  end
  
  def self.post_each_parse path
    filename = Parser.config['PageStore']+'report'    
    @@hashes.push(Parser::current_hash)
  end
  
  def self.post_parse *args
    dir = Parser.config['PageStore']+Parser.config['ClientAlias']
    FileUtils.mkdir_p dir unless File.directory?dir
    filename = dir +'/report'     
    open(filename, 'w') { |f| f.puts @@hashes.to_json}
  end
  
end