# encoding: utf-8
require "logstash/codecs/base"

# The rubydebug codec will output your Logstash event data using
# the Ruby Awesome Print library.
#
class LogStash::Codecs::RubyDebug < LogStash::Codecs::Base
  config_name "rubydebug"
  milestone 3

  # Show metadata in output
  # Default: false
  config :show_metadata, :validate => :boolean, :default => false

  def register
    require "awesome_print"
  end

  public
  def decode(data)
    raise "Not implemented"
  end # def decode

  public
  def encode(event)
    if @show_metadata
      @on_event.call(event.to_hash_with_metadata.awesome_inspect + NL)
    else
      @on_event.call(event.to_hash.awesome_inspect + NL)
    end
  end # def encode

end # class LogStash::Codecs::Dots
