require 'csv'
require 'json'
require 'open-uri'
require 'progress_bar'

def get_classes
  @classes ||= begin
    f = get_cached_file("classes.json") do
      open("https://www.warcraftlogs.com/v1/classes?api_key=#{ENV['API_KEY']}").read
    end
    JSON.parse f
  end
end

def get_zones
  @zones ||= begin
    f = get_cached_file("zones.json") do
      open("https://www.warcraftlogs.com/v1/zones?api_key=#{KEY}").read
    end
    JSON.parse f
  end
end

def class_slug(klass)
  klass.downcase.gsub(/[^a-z]/i, "_")
end

def get_class(klass)
  get_classes.detect {|c| class_slug(c["name"]) == class_slug(klass) }
end

def get_cached_file(file, &block)
  Dir.mkdir("cache") unless Dir.exists?("cache")
  target = File.join("cache", file)
  if File.exists?(target)
    File.read(target)
  else
    source = yield
    open(target, "w") {|fp| fp.puts source }
    source
  end
end