module Bot
  class Http # :nodoc:
    attr_reader :doc, :req_opts
    attr_accessor :hydra

    def initialize(opts)
      @doc = Nokogiri::HTML opts[:doc]

      # NOTE: enabling memoization produces an out of memory exception >_<
      # Typhoeus::Config.memoize = true
      @hydra = Typhoeus::Hydra.new max_concurrency: 1
      @req_opts = { followlocation: true }
    end

    def run
      reqs = requests doc
      puts '[run] running requests...'
      # puts "[run] hydra.queue before #{hydra.inspect}"
      hydra.run
      # hydra = nil
      # puts "[run] hydra.queue after #{hydra.inspect}"
      puts '[run] done'
      responses reqs
    end

    private

    def requests(doc)
      reqs = doc.css('//a.collection-char-name-link').each_with_object([]) do |node, memo|
        next if node['href'].match? %r{/characters}

        req = Typhoeus::Request.new "#{BASE_URL}#{node['href']}", req_opts
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
          puts 'request timed out'
        elsif req.response.code.zero?
          puts "couldn't get http response"
        elsif req.response.code == 402
          puts 'payment required?! >_<'
        else
          puts "failure: #{req.response.code} #{req.response.message} for #{req.response.effective_url}"
        end
      end
    end
  end
end
