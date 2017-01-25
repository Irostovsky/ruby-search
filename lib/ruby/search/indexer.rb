class Ruby::Search::Indexer
  attr_accessor :text
  def echo
    puts 'Test'
  end

  def index
    fetch_text
    arr = @text.split(/\W+/)
    tokens = arr.length.times.map{|i| arr.length.times.map{|j| arr[i..j].join(' ') unless i > j}}.flatten.compact
    p tokens
  end

  def fetch_text
    @text ||= "this is: a document, yo"
    p @text
  end
end