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

      event = LogStash::Event.new({"what" => "ok", "who" => 2222})

      on_event = lambda do |e, d|
        expect(d.chomp).to match(/\"ok\"/)
        expect(d.chomp).to match(/2222/)
        expect(d.chomp).to match(/@timestamp/)
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
