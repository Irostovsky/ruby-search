require 'yaml'

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

    p @text = IO.read(file_name)
    arr = @text.split(/\W+/)
    p tokens = arr.length.times.map{|i| arr.length.times.map{|j| arr[i..j].join(' ') unless i > j}}.flatten.compact
    p hash = tokens.inject({}){|h, s| h[s] ||= {file_name => 0}; h[s][file_name] += 1; h }
    File.open("index.yml","w") do |file|
       file.write hash.to_yaml
    end
  end


end