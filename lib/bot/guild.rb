module Bot
  class Guild # :nodoc:
    attr_reader :url

    # TODO: validate args
    def initialize(opts)
      id = opts[:id]
      name = opts[:name].tr ' ', '-'
      @url = "#{BASE_URL}/g/#{id}/#{name}/"
    end

    def run
      puts "[run] fetching #{url}..."
      res = Typhoeus.get url
      puts '[run] done'

      raise "couldn't GET #{guild_url}" unless res.success?

      players = parse res.body

      puts '[run] fetching stat power for players...'
      players.each do |player|
        puts "[run] working on player #{player}"
        bp = Bot::Player.new player: player
        sleep 180 unless bp.cached?
        bp.run
      end
      puts '[run] done'
    end

    def parse(body)
      doc = Nokogiri::HTML body

      doc.css('//td/a/@href').map(&:value).map { |uri| uri.split('/').last }
    end
  end
end
