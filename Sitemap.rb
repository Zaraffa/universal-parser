# encoding: utf-8
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

class Sitemap
  
  @@hooks = %w[post_each_parse]
  
  def self.hooks
    @@hooks if defined? @@hooks
  end    
    
  def self.filename
    @@filename
  end
  
  def post_each_parse *args
    
  end
  
  def initialize(url)
      @url = url      
      p @url
      dir = Parser::config['Sitemap_dir']+Parser::config['ClientAlias']
      FileUtils.mkdir_p dir unless File.directory?dir
      @@filename = dir+'/'+Parser::config['Sitemap_file']
      initToFile
  end
  
  def readFrom    
    return (File.exist?(@@filename) && ((Time.now - File.atime(@@filename))<(60*60*24)))            
  end
  
  def clearTarget
    File.truncate(@@filename, 0) if File.exist?(@@filename)
  end
  
  def initToFile
  if(@url)
    def toFile      
      return if readFrom      
      clearTarget
      sitemap = Hash.from_xml(open(@url, &:read))['urlset']['url']
      sitemap.each do |link| 
        if link['loc'] =~ Parser::config['SIteMap']
          sitemap_d = Hash.from_xml(open(link['loc'], &:read))['urlset']['url']
          sitemap.each do |link_d|
            next unless(link_d['loc'] =~ Parser::config['prefix'])    
            open(@@filename, 'a') { |f| f.puts "#{link_d['loc']}"}
          end
        else
          next unless(link['loc'] =~ Parser::config['prefix'])    
          open(@@filename, 'a') { |f| f.puts "#{link['loc']}"}
        end
      end        
    end
  else
    def toFile
      return if readFrom
      # clearTarget unless 
      i = 0;
      p 'here'
      Anemone.crawl(
                    Parser::config['Host'], 
                    :discard_page_bodies => true, 
                    :threads => Parser::config['Threads'], 
                    :obey_robots_txt => Parser::config['Respect_robots_file'], 
                    :user_agent => Parser::config['Botname'], 
                    :large_scale_crawl => true,
                    :delay => Parser::config['Interval'],
                    :verbose => Parser::config['Verbose'],
                    :read_timeout => 300
      ) do | anemone |
        
      anemone.skip_links_like eval(Parser::config['Skip']) if Parser::config['Skip']   
      anemone.storage = Anemone::Storage::MongoDB
                            
      anemone.on_pages_like(eval(Parser::config['Prefix'])) do | page |                                                                   
          res = open(@@filename).grep(Regexp::new(page.url.to_s))
          p res           
          if res.empty?
            p 'go next with '+page.url.to_s
            open(@@filename, 'a') { |f| f.puts "#{page.url}"}
            Parser::current_page = page.body
            p Parser::current_page                    
            post_each_parse page.url
          end                                                                                             
          page.discard_doc!    
      end  
      
      # anemone.on_every_page do |page|
        # p Parser::config['Skip']
        # next if page.url =~ 
        # # next unless page.url =~ Parser::confg['Prefix'] 
        # p page
      # end
      
    end
    end
  end
  end
  
  private :initToFile
  include Hooks
  
end