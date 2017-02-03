require 'yaml'
require 'active_support/core_ext/hash'

class Ruby::Search::Indexer
  include Ruby::Search::Indexable

  def index
    ARGV.each do |filename|
      puts "Process #{filename}..."
      file = Ruby::Search::IndexedFile.new filename
      if file.valid?
        @current_index.each{|k, v| @current_index[k].delete filename}
        open filename do |file|
          file.read.index_sanitize.each do |word|
            @current_index[word] ||= {}
            @current_index[word][filename] ||= 0
            @current_index[word][filename] += 1
          end
        end
        puts "[Done]"
      else
        puts file.errors.join(' ')
      end
    end

    open(@index_file_name, "w") do |index|
      index.write Marshal.dump(@current_index)
    end

  end

end

class String
  def index_sanitize
    self.split.collect do |token|
      token.downcase.gsub(/\W/, '')
    end
  end
end