require 'yaml'
require 'active_support/core_ext/hash'

class Ruby::Search::Indexer
  include Ruby::Search::Indexable

  def index
    indexed_file = Ruby::Search::IndexedFile.new ARGV[0]
    return puts indexed_file.errors unless indexed_file.valid?
    save merge_index indexed_file.index
    puts "Updated index: #{@index_file_name}"
  end

  private

    def save hash
      File.open(@index_file_name,"w") do |file|
         file.write hash.to_yaml
      end
    end

    def merge_index index
      @current_index.deep_merge(index){ |key, this_val, other_val| other_val }
    end
end