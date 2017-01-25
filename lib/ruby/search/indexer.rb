class Ruby::Search::Indexer
  attr_accessor :text
  def echo
    puts 'Test'
  end

  def index
    unless ARGV[0]
      return p 'No file path passed'
    end

    file_name = ARGV[0]

    unless File.exist?(file_name)
      return p "File #{file_name} does not exists"
    end

    @text = IO.read file_name
    arr = @text.split(/\W+/)
    tokens = arr.length.times.map{|i| arr.length.times.map{|j| arr[i..j].join(' ') unless i > j}}.flatten.compact
    p tokens
  end

  def fetch_text
    @text ||= "this is: a document, yo"
    p @text
  end
end