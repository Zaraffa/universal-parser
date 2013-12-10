module Anemone
  class Page
    def to_hash
      {'url' => @url.to_s,
       'links' => links.map(&:to_s),
       'code' => @code,
       'visited' => @visited,
       'depth' => @depth,
       'referer' => @referer.to_s,
       'fetched' => @fetched}
    end
    def self.from_hash(hash)
      page = self.new(URI(hash['url']))
      {'@links' => hash['links'].map { |link| URI(link) },
       '@code' => hash['code'].to_i,
       '@visited' => hash['visited'],
       '@depth' => hash['depth'].to_i,
       '@referer' => hash['referer'],
       '@fetched' => hash['fetched']
      }.each do |var, value|
        page.instance_variable_set(var, value)
      end
      page
    end
  end
end