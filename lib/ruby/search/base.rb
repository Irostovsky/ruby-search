class Ruby::Search::Base

  require 'pp'

  def initialize
    @current_index = File.exist?(Ruby::Search::Indexer::INDEX_STORE) ? YAML.load(IO.read(Ruby::Search::Indexer::INDEX_STORE)) : {}
  end

  def search
    unless ARGV.any?
      return p 'No search keywords passed'
    end
    ARGV.each_with_index do |keyword, i|
      puts ""
      puts "Searching for #{keyword} ..."
       if match = @current_index[keyword]
          puts "    Found in:"
          match.sort_by {|_key, value| -value}.to_h.each do |name, count|
            puts "        #{name} : #{count}"
          end
       else
          puts "No matches found."
       end
    end
  end
end