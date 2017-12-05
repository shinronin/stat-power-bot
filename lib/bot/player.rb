module Bot
  class Player # :nodoc:
    include ::ActionView::Helpers::NumberHelper

    attr_reader :player, :collection_file, :collection_url, :cache_file

    # TODO: validate args
    def initialize(opts)
      @player = opts[:player]
      # @collection_file =  File.exist?(opts[:file]) ? File.read(opts[:file]) : nil
      @collection_url  = "#{BASE_URL}/u/#{@player}/collection/"
      @cache_file = "cache/#{@player}.json"
      # NOTE: File.size > 4 will be true if the file isn't an empty {}
      @cached = File.exist?(cache_file) && File.size(cache_file) > 4
    end

    def cached?
      @cached
    end

    def run
      stats = fetch_stats
      top = stats.take 5
      sum = top.map { |_name, power| power }.reduce(:+)

      top.each do |k, v|
        puts "#{k} #{number_with_delimiter v}"
      end

      puts "Your total stat power is #{number_with_delimiter sum}. " \
        'GW node 12 should break at approximately 54k, but as early as 53k.'
    end

    private

    def fetch_stats
      if cached?
        puts '[fetch_stats] stat power is already cached'
        return ::JSON.parse(File.read(cache_file), symbolize_names: true)
      end

      resps = fetch_collection
      stats = resps.each_with_object({}) do |body, memo|
        name, power = parse body
        memo[name] = power.to_i
      end

      sorted = sort stats
      cache sorted

      sorted
    end

    def fetch_collection
      puts '[fetch_collection] fetching collection...'
      res = collection_file ? Nokogiri::HTML(collection_file) : Typhoeus.get(collection_url)
      puts '[fetch_collection] done'

      raise "couldn't GET #{collection_url}" unless res.success?

      bh = Bot::Http.new doc: res.body
      bh.run
    end

    def parse(body)
      doc = Nokogiri::HTML body
      name = doc.css('//li.active')[0].text
      power = doc.css('//span.pc-stat-value')[1].text

      [name, power]
    end

    def cache(stats)
      # TODO: add timestamp and allow access every 24+ hours
      File.open(cache_file, 'w') { |f| f.write JSON.pretty_generate stats }
    end

    def sort(stats)
      stats.sort_by { |_name, power| power }.reverse.to_h
    end
  end
end
