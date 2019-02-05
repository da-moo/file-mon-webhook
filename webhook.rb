require 'active_support/core_ext/integer/time'
require 'configatron'
require 'discordrb/webhooks'
require 'filesize'
require 'listen'
require 'pry'

require_relative 'config/config.rb'

@webhook_client = Discordrb::Webhooks::Client.new(url: configatron.url)

listener = Listen.to(*configatron.directories, 
                    force_polling: true,
                    latency: configatron.poll_latency,
                    wait_for_delay: configatron.delay_between_callbacks,
                    ignore: configatron.ignore_patterns) do |modified, added, removed|
  unless added.empty?
    send_embed(build_embed(added))
  end
  unless modified.empty?
    send_embed(build_embed(modified))
  end
end

def send_embed(embed)
  @webhook_client.execute do |builder|
    builder.username = configatron.username
    builder.avatar_url = configatron.avatar_url
    builder << embed
  end
end

def build_embed(paths)
  embed = Discordrb::Webhooks::Embed.new
  embed.colour = 0xff0000
  embed.timestamp = Time.now
  embed.author = Discordrb::Webhooks::EmbedAuthor.new(
    name: configatron.embed_title,
    icon_url: configatron.author_url
  )
  paths.each do |path|
    embed.add_field(create_embed_field(path))
  end
  embed
end

def create_embed_field(path)
  {
    name: pretty_path(path),
    value: pretty_file_size(path),
    inline: true
  }
end

# From https://stackoverflow.com/a/42802577
def recurse_folder_size(folder_path)
  Dir.glob(File.join(folder_path, '**', '*'))
  .map{ |f| File.size(f) }
  .inject(:+)
end

def pretty_file_size(path)
  size = File.directory?(path) ? recurse_folder_size(path) : File.size(path)
  Filesize.new(size).pretty
end

def pretty_path(absolute_path)
  parent_dir = File.basename(File.dirname(absolute_path))
  basename = File.basename(absolute_path)
  parent_dir + '/' + basename
end

listener.start
pry

