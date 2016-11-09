require_relative './util'
require 'net/http'

KEY = ENV['API_KEY']
TEMPLATE = "https://www.warcraftlogs.com/v1/rankings/encounter/%d?api_key=%s&class=%d&spec=%d&bracket=%d&limit=1000&metric=dps&difficulty=%d"

desired_class = ARGV[0]
slug = class_slug(desired_class)
DIFFICULTIES = [[3, "Normal"], [4, "Heroic"], [5, "Mythic"]]
KLASS = get_class(desired_class)
BRACKETS = (6..16)
DIFFICULTY_NAMES = %w(Normal Heroic Mythic)
SKIP_SPECS = %w(Restoration Combat Holy Protection Guardian Vengence Blood Discipline Brewmaster Mistweaver)

raise "Could not find specs for class: #{desired_class}" if KLASS.nil?
class_id = KLASS["id"]

encounters = get_zones.detect {|z| z["id"] == 10 }["encounters"]
bar = ProgressBar.new(encounters.length * (KLASS["specs"].map {|s| s["name"] } - SKIP_SPECS).length * DIFFICULTIES.length * BRACKETS.to_a.length)

target_dir = File.join("data", slug)
Dir.mkdir(target_dir) unless Dir.exists?(target_dir)

encounters.each do |encounter|
  KLASS["specs"].each do |spec|
    next if SKIP_SPECS.include?(spec["name"])
    DIFFICULTIES.each do |difficulty_id, difficulty_name|
      BRACKETS.each do |bracket|
        bar.increment!
        url = format(TEMPLATE, encounter["id"], KEY, class_id, spec["id"], bracket, difficulty_id)
        file = File.join target_dir, format("%s-%s-%s-%s.json", encounter["name"].gsub(/[^a-z]/i, "_"), spec["name"], bracket, difficulty_name)
        unless File.exists?(file)
          json = Net::HTTP.get(URI.parse(url))
          open(file, "w") {|fp| fp.puts json }
        end
      end
    end
  end
end
