class Ruby::Search::Base
  include Ruby::Search::Indexable

  def search
    return puts 'No search keywords passed' unless ARGV.any?
    print_result do_search ARGV
  end

private

  def print_result data
    data.each_with_index do |item, i|
      puts ""
      keyword = item.shift
      puts "#{i+1}. Searching for '#{keyword}' ..."
      if item.any?
        puts "   Found in:"
        item.each do |file, count|
          puts "        #{file} : #{count}"
        end
      else
        if keyword.split(/\W+/).length > Ruby::Search.configuration.sentence_words_count
          puts "WARNING: Too long sentence, #{Ruby::Search.configuration.sentence_words_count} words are allowed"
        end
        puts "No matches found."
      end
    end
  end

  def do_search args
    keywords(args).map do |keyword|
      keyword_str = keyword.join(" #{Ruby::Search.configuration.and_symbol} ")
      res = [keyword_str]
      matches = keyword.map{|k| @current_index[k]}
      if matches.compact.length == keyword.length
        keys = matches.map(&:keys).inject(:&)
        if keys.any?
          sorted_matches = matches.sort_by{|h| -keys.map{|k| h[k]}.inject(:+)}
          match = Hash[keys.zip(sorted_matches.first.values_at(*keys))]
          match.sort_by {|key, value| -value}.to_h.each do |name, count|
            res << [name, count]
          end
        end
      end
      res
    end
  end

  def keywords arr
    res = []
    and_marker = false
    arr.each_with_index do |i, counter|
      if and? i
        and_marker = true unless counter.zero?
      else
        and_marker ? res << [res.pop, i].flatten : res << [i]
        and_marker = false
      end
    end
    res
  end

  def and? str
    str == Ruby::Search.configuration.and_symbol
  end
end