Gem::Specification.new do |s|

  s.name            = 'logstash-codec-rubydebug'
  s.version         = '0.1.1'
  s.licenses        = ['Apache License (2.0)']
  s.summary         = "The rubydebug codec will output your Logstash event data using the Ruby Awesome Print library."
  s.description     = "The rubydebug codec will output your Logstash event data using the Ruby Awesome Print library."
  s.authors         = ["Elasticsearch"]
  s.email           = 'richard.pijnenburg@elasticsearch.com'
  s.homepage        = "http://logstash.net/"
  s.require_paths = ["lib"]

  # Files
  s.files = `git ls-files`.split($\)

  # Tests
  s.test_files = s.files.grep(%r{^(test|spec|features)/})

  # Special flag to let us know this is actually a logstash plugin
  s.metadata = { "logstash_plugin" => "true", "group" => "codec" }

  # Gem dependencies
  s.add_runtime_dependency 'logstash', '>= 1.4.0', '< 2.0.0'

  s.add_runtime_dependency 'awesome_print'

end

