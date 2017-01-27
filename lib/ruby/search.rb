require "ruby/search/version"
require "ruby/search/utils/mime_detector"
require "ruby/search/indexed_file"
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
      attr_accessor :index_file_name, :and_symbol
    end

    Ruby::Search.configure  do |config|
      config.index_file_name = 'index.yml'
      config.and_symbol = 'AND'
    end
  end
end