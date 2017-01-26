class Ruby::Search::Base
  include Ruby::Search::Indexable

  def search
    unless ARGV.any?
      return p 'No search keywords passed'
    end
    puts ARGV
    keywords(ARGV).each_with_index do |keyword, i|
      puts ""
      if keyword.is_a? Array
        keyword_str = keyword.join(" #{Ruby::Search.configuration.and_symbol} ")
        puts "Searching for '#{keyword_str}' ..."
        p keys = keyword.map{|k| @current_index[k].try :keys}
        if keys.compact.length == keyword.length
          match = keys.inject(:&)
          if match.any?
            puts "    Found in:"
            match.each do |name|
              puts "        #{name}"
            end
          else
            puts "No matches found."
          end
        else
          puts "No matches found."
        end
      else
        puts "Searching for '#{keyword}' ..."
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

private

  def keywords arr
    [nil, *arr, nil].each_cons(3).map do |group|
      if and? group[1]
        [group.first, group.last].compact
      else
        group[1] unless and?(group.first) || and?(group.last)
      end
    end.compact
  end

  def and? str
    str == Ruby::Search.configuration.and_symbol
  end
end