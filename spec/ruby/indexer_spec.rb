require "spec_helper"

RSpec.describe Ruby::Search::Indexer do
  describe '#save' do
    before :each do
      @file_name = "spec/tmp/index.yml"
      Ruby::Search.configure  do |config|
        config.index_file_name = @file_name
      end
    end

    after(:each) do
      FileUtils.rm_f(@file_name)
    end

    it 'should write hash to index file' do
      indexer = described_class.new
      hash = {'str' => {'file' => 1}, 'str2' => {'file2' => 1, 'file' => 2}}
      indexer.send :save, hash
      expect(YAML.load(IO.read(@file_name))).to eq hash
    end
  end
end
