module Bot
  class Http # :nodoc:
    attr_reader :doc, :hydra

    def initialize(opts)
      @doc = Nokogiri::HTML opts[:doc]

      Typhoeus::Config.memoize = true
      @hydra = Typhoeus::Hydra.new max_concurrency: 5
    end

    def run
      reqs = requests doc
      hydra.run
      responses reqs
    end

    def requests(doc)
      reqs = doc.css('//a[@class = "collection-char-name-link"]').each_with_object([]) do |node, memo|
        next if node['href'].match? %r{/characters}

        req = Typhoeus::Request.new "#{BASE_URL}#{node['href']}", followlocation: true
        hydra.queue req
        memo << req
      end

      reqs
    end

    def responses(reqs)
      reqs.each_with_object([]) do |req, memo|
        if req.response.success?
          memo << req.response.body
        elsif req.response.timed_out?
          ap 'request timed out'
        elsif req.response.code.zero?
          ap "couldn't get http response"
        else
          ap 'failure'
        end
      end
    end
  end
end
