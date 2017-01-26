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

end