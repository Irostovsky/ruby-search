require 'yaml'
require 'active_support/core_ext/hash'

class Ruby::Search::Indexer
  include Ruby::Search::Indexable

  def index
    unless ARGV[0]
      return puts 'No file path passed'
    end

    file_name = ARGV[0]

    unless File.exist?(file_name)
      return puts "File #{file_name} does not exists"
    end

    text = IO.read(file_name)
    tokens = text.split(/\W+/)
    # tokens = arr.length.times.map{|i| arr.length.times.map{|j| arr[i..j].join(' ') unless i > j}}.flatten.compact
    new_index = tokens.inject({}){|h, s| h[s] ||= {file_name => 0}; h[s][file_name] += 1; h }
    res = @current_index.deep_merge(new_index){ |key, this_val, other_val| other_val }
    File.open(Ruby::Search.configuration.index_file_name,"w") do |file|
       file.write res.to_yaml
    end
  end


end