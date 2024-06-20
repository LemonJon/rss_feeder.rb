require 'open-uri'
require 'rss'

def fetch_rss_feed(url)
    @width = 100
    begin
        content = URI.open(url).read
        rss = RSS::Parser.parse(content, false)
        
        # Check if it's an RSS 2.0 feed
        if rss.channel && rss.channel.items
            items = rss.channel.items
        # Check if it's an RSS 1.0 feed
        elsif rss.items
            items = rss.items
        else
            puts "Unsupported RSS feed format."
            return
        end

        items.each do |item|
            puts "\n" + bold("#{item.title}") if item.title
            puts blue(italic("#{item.link}")) if item.link
            puts "#{wrap_text(strip_tags(item.description), @width)}" if item.description
            puts italic(item.pubDate) if item.pubDate
            puts "\n #{bold("Author: ")}#{item.author}" if item.author
            puts "\n" + ("-" * @width)
        end
    rescue OpenURI::HTTPError => e
        puts "Failed to retrieve RSS feed: #{e.message}"
    rescue RSS::Error => e
        puts "Failed to parse RSS feed: #{e.message}"
    rescue => e
        puts "An error occurred: #{e.message}"
    end
end

# Text formatting
def wrap_text(text, line_width)
    return '' unless text
    text.split("\n").map do |line|
        line.gsub(/(.{1,#{line_width}})(\s+|\Z)/, "\\1\n")
    end.join('\n')
end

def strip_tags(text)
    text.gsub(/<\/?[^>]*>/, " ")
end


# Text decorations
def bold(text)
    "\e[1m#{text}\e[22m"
end

def italic(text)
    "\e[3m#{text}\e[23m"
  end
  
def blue(text)
"\e[34m#{text}\e[0m"
end

puts "Enter the URL of the RSS feed:"
url = gets.chomp
fetch_rss_feed(url)
