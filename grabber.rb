require_relative './util'

KEY = ENV['API_KEY']
TEMPLATE = "https://www.warcraftlogs.com/v1/rankings/encounter/%d?api_key=%s&class=8&spec=%d&bracket=%d&limit=1000&metric=dps&difficulty=%d"

desired_class = ARGV[0]
slug = class_slug(desired_class)
DIFFICULTIES = [[3, "Normal"], [4, "Heroic"], [5, "Mythic"]]
KLASS = get_class(desired_class)
BRACKETS = (6..16)
DIFFICULTY_NAMES = %w(Normal Heroic Mythic)

raise "Could not find specs for class: #{desired_class}" if KLASS.nil?

bar = ProgressBar.new(KLASS["specs"].length * DIFFICULTIES.length * BRACKETS.to_a.length)

target_dir = File.join("data", slug)
Dir.mkdir(target_dir) unless Dir.exists?(target_dir)

get_zones.detect {|z| z["id"] == 10 }["encounters"].each do |encounter|
  KLASS["specs"].each do |spec|
    next if spec["name"] == "Combat"
    DIFFICULTIES.each do |difficulty_id, difficulty_name|
      BRACKETS.each do |bracket|
        bar.increment!
        url = format(TEMPLATE, encounter["id"], KEY, spec["id"], bracket, difficulty_id)
        file = File.join target_dir, format("%s-%s-%s-%s.json", encounter["name"].gsub(/[^a-z]/i, "_"), spec["name"], bracket, difficulty_name)
        unless File.exists?(file)
          json = open(url).read
          open(file, "w") {|fp| fp.puts json }
        end
      end
    end
  end
end
