require 'anemone'
require_relative 'AppConfig'
require 'nokogiri'
require_relative 'Parser'
require_relative 'Sitemap'
require 'yaml'
require 'open-uri'
require 'active_support/core_ext/hash/conversions'

class Runner
  def self.main
    config = ARGV.first
    conf = AppConfig.new('./configs/sample.yaml');
    conf = conf.object
    parser = Parser.new(conf)
    parser.parse
  end
end

Runner::main
