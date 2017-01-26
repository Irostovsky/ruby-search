require "spec_helper"

RSpec.describe Ruby::Search do
  describe 'validation' do
    before :each do
      @file_name = "spec/tmp/test_text.txt"
      File.open(@file_name,"w") do |file|
        file.write 'my some text'
      end
    end

    after(:each) do
      FileUtils.rm_f(@file_name)
    end

    it 'should be valid if passed file exists' do
      indexed_file = Ruby::Search::IndexedFile.new @file_name
      expect(indexed_file).to be_valid
      expect(indexed_file.name).to eq @file_name
      expect(indexed_file.errors).to be_blank
    end

    it 'should be not valid if nothing passed' do
      indexed_file = Ruby::Search::IndexedFile.new
      expect(indexed_file).to_not be_valid
      expect(indexed_file.name).to be_blank
      expect(indexed_file.errors).to eq ['No file path passed']
    end

    it 'should be not valid if file does not exist' do
      other_file = 'other_file'
      indexed_file = Ruby::Search::IndexedFile.new other_file
      expect(indexed_file).to_not be_valid
      expect(indexed_file.name).to eq other_file
      expect(indexed_file.errors).to eq ["File #{other_file} does not exists"]
    end
  end

  describe '#extract_tokens' do
    it 'should split by space' do
      indexed_file = Ruby::Search::IndexedFile.new
      # expect(indexed_file.send :extract_tokens, 'my super:  string').to eq ['my', 'super', 'string']
      expect(indexed_file.send :extract_tokens, 'my super:  string').to eq ["my", "my super", "my super string", "super", "super string", "string"]
    end
  end

  describe '#hash_view' do
    it 'should convert tokens to hash view' do
      indexed_file = Ruby::Search::IndexedFile.new 'to_index'
      tokens = "super super string".split(' ')
      expect(indexed_file.send(:hash_view, tokens)).to eq({
        "super" => {indexed_file.name => 2},
        'string' => {indexed_file.name => 1}
      })
    end
  end

  describe '#index' do
    it 'should call needed methods' do
     indexed_file = Ruby::Search::IndexedFile.new 'to_index'
     expect(IO).to receive(:read).with(indexed_file.name).and_return(:text)
     expect(indexed_file).to receive(:extract_tokens).with(:text).and_return(:arr)
     expect(indexed_file).to receive(:hash_view).with(:arr).and_return(:hash)
     expect(indexed_file.index).to eq :hash
    end
  end
end