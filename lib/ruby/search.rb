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
      attr_accessor :index_file_name, :and_symbol, :sentence_words_count
    end

    Ruby::Search.configure  do |config|
      config.index_file_name = 'index.dat'
      config.and_symbol = 'AND'
      config.sentence_words_count = 1
    end
  end
end