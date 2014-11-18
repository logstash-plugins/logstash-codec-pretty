require "logstash/devutils/rspec/spec_helper"
require "logstash/codecs/rubydebug"
require "logstash/event"
require "awesome_print"
require "insist"

describe LogStash::Codecs::RubyDebug do


  subject do
    next LogStash::Codecs::RubyDebug.new
  end

  context "#encode" do
    it "should print beautiful hashes" do
      test_event = LogStash::Event.new({"what" => "ok", "who" => 2})
      got_event = false
      subject.on_event do |d|
        insist { d.chomp } == test_event.to_hash.awesome_inspect 
        got_event = true
      end
      subject.encode(test_event)
      insist { got_event }
    end
  end

  context "#decode" do
    it "should not be implemented" do
      expect { subject.decode("data") }.to raise_error("Not implemented")
    end
  end
end
