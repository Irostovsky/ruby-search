module Ruby::Search::Indexable

  def initialize
    @index_file_name = Ruby::Search.configuration.index_file_name
    @current_index = File.exist?(@index_file_name) ? Marshal.load(open(@index_file_name)) : {}
  end

end