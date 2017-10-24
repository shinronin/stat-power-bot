module Bot
  class Power # :nodoc:
    include ActionView::Helpers::NumberHelper

    attr_reader :user, :collection_url, :cache_file

    def initialize(opts)
      @user = opts[:user]
      @collection_url = "#{BASE_URL}/u/#{@user}/collection/"
      @cache_file = "cache/#{@user}.json"
    end

    def run
      stats = fetch_stats
      top = Hash[stats.sort { |a, b| b[1].to_i <=> a[1].to_i }.take(5)]
      sum = top.values.map(&:to_i).reduce(:+)

      top.each do |k, v|
        puts "#{k} #{number_with_delimiter v}"
      end

      puts "Total stat power #{number_with_delimiter sum}"
    end

    def fetch_stats
      return ::JSON.parse(File.read(cache_file), symbolize_names: true) if File.exist? cache_file

      resps = fetch_collection
      stats = resps.each_with_object({}) do |body, memo|
        name, power = parse body
        memo[name] = power
      end

      cache stats

      stats
    end

    def fetch_collection
      res = Typhoeus.get collection_url

      raise "couldn't GET #{collection_url}" unless res.success?

      bh = Bot::Http.new doc: res.body
      bh.run
    end

    def parse(body)
      doc = Nokogiri::HTML body
      name = doc.css('//li[@class = "active"]')[0].text
      power = doc.css('//span[@class = "pc-stat-value"]')[1].text

      [name, power]
    end

    def cache(stats)
      # TODO: add timestamp and allow access every 24+ hours
      File.open(cache_file, 'w') { |f| f.write JSON.pretty_generate(stats) }
    end
  end
end
