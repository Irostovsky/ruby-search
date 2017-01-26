module Ruby::Search::Indexable

  def initialize
    filename = Ruby::Search.configuration.index_file_name
    @current_index = File.exist?(filename) ? YAML.load(IO.read(filename)) : {}
  end

end