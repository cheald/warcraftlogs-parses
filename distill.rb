require_relative './util'

desired_class = ARGV[0]
raise "Usage: distill.rb [class]" unless desired_class
slug = class_slug(desired_class)
SPECS = get_class(slug)["specs"].each_with_object({}) {|s, o| o[s["id"].to_s] = s["name"] }

CSV.open("csv/#{slug}.csv", "w") do |csv|
  csv << ["encounter", "difficulty", "spec", "ilvl", "dps", "date"]

  files = Dir.glob("data/#{slug}/*.json")
  bar = ProgressBar.new(files.length)
  files.each do |json|
    bar.increment!
    bits = json.split("/").last.split(/[\/\-.]/)
    json = JSON.parse(File.read(json))
    json["rankings"].select {|r| r["exploit"] == 0 }.each do |r|
      csv << [bits[0], bits[3], SPECS[r["spec"].to_s], r["itemLevel"].to_i, r["total"].to_i, Time.at(r["startTime"] / 1000)]
    end
  end
end
