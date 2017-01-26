require "spec_helper"

RSpec.describe Ruby::Search::Base do

  describe '#and?' do
    before :each do
      Ruby::Search.configure  do |config|
        config.and_symbol = 'AND'
      end
    end
    it 'should be true' do
      expect(described_class.new.send(:and?, 'AND')).to eq true
    end

    it 'should be false' do
      expect(described_class.new.send(:and?, 'not AND')).to eq false
    end
  end

  describe '#keywords' do
    it 'normal case' do
      expect(described_class.new.send(:keywords, ['find', 'this'])).to eq ['find', 'this']
    end

    it 'sentence passed' do
      expect(described_class.new.send(:keywords, ['find me', 'this'])).to eq ['find me', 'this']
    end

    it 'AND query' do
      expect(described_class.new.send(:keywords, ['less', 'AND', 'sass'])).to eq [['less', 'sass']]
      expect(described_class.new.send(:keywords, ['first' ,'less', 'AND', 'sass', 'last'])).to eq ['first', ['less', 'sass'], 'last']
    end

    # it 'AND query several times' do
    #   expect(described_class.new.send(:keywords, ['less', 'AND', 'sass', 'AND', 'ruby'])).to eq [['less', 'sass', 'ruby']]
    # end

    it 'ignore AND query in the start' do
      expect(described_class.new.send(:keywords, ['AND', 'sass'])).to eq [['sass']]
      expect(described_class.new.send(:keywords, ['less', 'AND'])).to eq [['less']]
    end
  end
end