module Ruby::Search::Indexable

  def initialize
    @current_index = File.exist?(Ruby::Search::Indexer::INDEX_STORE) ? YAML.load(IO.read(Ruby::Search::Indexer::INDEX_STORE)) : {}
  end

end