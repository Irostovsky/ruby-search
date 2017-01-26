require "ruby/search/version"
require "ruby/search/indexable"
require "ruby/search/indexer"
require "ruby/search/base"

module Ruby
  module Search
    class << self
      attr_accessor :configuration
    end

    def self.configure
      self.configuration ||= Configuration.new
      yield(configuration) if block_given?
    end

    class Configuration
      attr_accessor :index_file_name
    end

    Ruby::Search.configure  do |config|
      config.index_file_name = 'index.yml'
    end
  end
end