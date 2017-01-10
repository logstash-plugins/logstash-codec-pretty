require "logstash/devutils/rspec/spec_helper"
require "logstash/codecs/rubydebug"
require "logstash/event"

describe LogStash::Codecs::RubyDebug do

  # This is a necessary monkey patch that ensures that if ActiveSupport
  # is defined, then the on_load method exists.
  # The awesome_print gem uses this method to hook extra funcionality if
  # ActiveSupport is loaded. Since some versions of ActiveSupport don't
  # have the on_load method we must ensure this method exists.
  # More information:
  # * https://github.com/logstash-plugins/logstash-codec-rubydebug/issues/8
  # * https://github.com/michaeldv/awesome_print/pull/206
  before(:all) do
    if defined?(ActiveSupport) && !ActiveSupport.respond_to?(:on_load)
      module ActiveSupport
        def self.on_load(*params); end
      end
    end
  end

  subject { LogStash::Codecs::RubyDebug.new }

  context "#encode" do
    it "should print beautiful hashes" do
      subject.register

      event = LogStash::Event.new({"what" => "ok", "who" => 2})
      # with the new java event the to_hash function returns different instances each time
      # the timestamp field will 'inspect' to a different string each time to_hash is called
      expected = event.to_hash.awesome_inspect.gsub(/LogStash::Timestamp:0x\h{7,8}/, 'LogStash::Timestamp:0x')

      on_event = lambda do |e, d|
        actual = d.chomp.gsub(/LogStash::Timestamp:0x\h{7,8}/, 'LogStash::Timestamp:0x')
        expect(actual).to eq(expected)
      end
      
      subject.on_event(&on_event)
      expect(on_event).to receive(:call).once.and_call_original

      subject.encode(event)
    end
  end

  context "#decode" do
    it "should not be implemented" do
      expect { subject.decode("data") }.to raise_error("Not implemented")
    end
  end
end
