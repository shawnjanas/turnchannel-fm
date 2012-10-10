# This initializer provides a handy namespace for all of the 3rd party
# app data we need to manage to integrate with the commenting networks.
# Eg. API keys, callback URLs, etc.
#
# This will load the config for the current stage (dev, staging, production),
# and populate the handy Network class so that we can do fun things like
# call:
#
# Network[:facebook][:api_key] # => our facebook API key
# Network[:twitter][:callback] # => some callback URL
#
# This is all freeform, check out the configurations in config/networks.yml

# needed by serel gem if we use it
# require 'webmock'
# WebMock.allow_net_connect!(:net_http_connect_on_start => true)

require 'httparty'

class Network
  @@network_data = {}
  def self.[]=(*args); @@network_data.send(:[]=, *args); end
  def self.[](*args);  @@network_data.send(:[], *args);  end

  # Turn string keys into symbol keys, recursively
  # via http://www.any-where.de/blog/ruby-hash-convert-string-keys-to-symbols/
  def self.transform_keys_to_symbols(value)
    return value if not value.is_a?(Hash)
    hash = value.inject({}){|memo,(k,v)| memo[k.to_sym] = self.transform_keys_to_symbols(v); memo}
    return hash
  end
end

config = Network.transform_keys_to_symbols(YAML.load_file(File.dirname(__FILE__) + '/../networks.yml'))
config[Rails.env.to_sym].each {|k, v| Network[k] = v} if config[Rails.env.to_sym]
