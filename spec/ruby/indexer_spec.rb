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

  describe '#merge_index' do
    it 'should merge with empty current hash' do
      indexer = described_class.new
      indexer.instance_variable_set :@current_index, {}
      hash = {'str' => {'file' => 1}, 'str2' => {'file2' => 1, 'file' => 2}}
      expect(indexer.send(:merge_index, hash)).to eq hash
    end

    it 'should merge with not empty curent hash' do
      indexer = described_class.new
      indexer.instance_variable_set :@current_index, {'str' => {'file1' => 1}, 'str2' => {'file1' => 1}}
      hash = {'str' => {'file1' => 1, 'file2' => 2}, 'str2' => {'file2' => 2}, 'str3' => {'file' => 1}}
      expect(indexer.send(:merge_index, hash)).to eq({
        'str' => {'file1' => 1, 'file2' => 2},
        'str2' => {'file2' => 2, 'file1' => 1},
        'str3' => {'file' => 1}
      })
    end
  end
end
