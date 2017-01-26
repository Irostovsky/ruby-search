class Ruby::Search::Base
  include Ruby::Search::Indexable

  def search
    return puts 'No search keywords passed' unless ARGV.any?

    keywords(ARGV).each_with_index do |keyword, i|
      puts ""
      keyword_str = keyword.join(" #{Ruby::Search.configuration.and_symbol} ")
      puts "#{i+1}. Searching for '#{keyword_str}' ..."
      matches = keyword.map{|k| @current_index[k]}
      if matches.compact.length == keyword.length
        keys = matches.map(&:keys).inject(:&)
        if keys.any?
          sorted_matches = matches.sort_by{|h| -keys.map{|k| h[k]}.inject(:+)}
          match = Hash[keys.zip(sorted_matches.first.values_at(*keys))]

          puts "   Found in:"
          match.sort_by {|key, value| -value}.to_h.each do |name, count|
            puts "        #{name} : #{count}"
          end
        else
          puts "No matches found."
        end
      else
        puts "No matches found."
      end
    end
  end

private

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