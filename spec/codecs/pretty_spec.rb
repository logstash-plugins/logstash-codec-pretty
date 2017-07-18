require "logstash/devutils/rspec/spec_helper"
require "logstash/codecs/pretty"
require "logstash/event"

describe LogStash::Codecs::Pretty do

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

  subject { LogStash::Codecs::Pretty.new }

  context "#encode" do
    it "should print beautiful hashes" do
      subject.register

      event = LogStash::Event.new({"what" => "ok", "who" => 2})
      on_event = lambda { |e, d| expect(d.chomp).to eq(event.to_hash.awesome_inspect) }

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
