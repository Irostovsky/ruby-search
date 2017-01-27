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
      expect(described_class.new.send(:keywords, ['find', 'this'])).to eq [['find'], ['this']]
    end

    it 'sentence passed' do
      expect(described_class.new.send(:keywords, ['find me', 'this'])).to eq [['find me'], ['this']]
    end

    it 'AND query' do
      expect(described_class.new.send(:keywords, ['less', 'AND', 'sass'])).to eq [['less', 'sass']]
      expect(described_class.new.send(:keywords, ['first' ,'less', 'AND', 'sass', 'last'])).to eq [['first'], ['less', 'sass'], ['last']]
    end

    it 'AND query several times' do
      expect(described_class.new.send(:keywords, ['less', 'AND', 'sass', 'AND', 'ruby'])).to eq [['less', 'sass', 'ruby']]
    end

    it 'AND query several groups' do
      expect(described_class.new.send(:keywords, ['less', 'AND', 'sass', 'rails', 'AND', 'ruby'])).to eq(
        [['less', 'sass'], ['rails', 'ruby']]
      )
    end

    it 'ignore AND query in the start' do
      expect(described_class.new.send(:keywords, ['AND', 'sass'])).to eq [['sass']]
    end

    it 'ignore AND query in the end' do
      expect(described_class.new.send(:keywords, ['less', 'AND'])).to eq [['less']]
    end
  end

  describe '#do_search' do

    it 'several keywords' do
      index = {
        'ruby' => {
          'file2' => 2,
        },
        'rails' => {
          'file1' => 2
        }
      }
      expect_search index, 'ruby', 'on', 'rails' do
        [
          ['ruby', ['file2', 2]],
          ['on'],
          ['rails', ['file1', 2]]
        ]
      end
    end

    it 'ordered files by count' do
      index = {
        'ruby' => {
          'file2' => 2,
          'file3' => 3,
        }
      }
      expect_search index, 'ruby' do
        [
          ['ruby', ['file3', 3], ['file2', 2]]
        ]
      end
    end

    it 'search sentence, with order' do
      index = {
        'ruby on rails' => {
          'file2' => 2,
          'file3' => 3,
        },
        'less' => {
          'file2' => 1
        }
      }
      expect_search index, "less", "ruby on rails" do
        [
          ['less', ['file2', 1]],
          ['ruby on rails', ['file3', 3], ['file2', 2]]
        ]
      end
    end

    context 'AND query' do
      let(:index) do
        {
          'ruby' => {
            'file2' => 2,
            'file3' => 3,
          },
          'rails' => {
            'file2' => 3,
            'file4' => 4,
          },
          'less' => {
            'file2' => 1
          },
          'less sass' => {
            'file2' => 1
          }
        }
      end
      it '2 items' do
        expect_search index, 'ruby', 'AND', 'rails' do
          [
            ['ruby AND rails', ['file2', 3]]
          ]
        end
      end

      it 'several items' do
        expect_search index, 'ruby', 'AND', 'rails', 'AND', 'less' do
          [
            ['ruby AND rails AND less', ['file2', 3]]
          ]
        end
      end

      it 'several groups' do
        expect_search index, 'ruby', 'AND', 'rails', 'less', 'AND', 'rails' do
          [
            ['ruby AND rails', ['file2', 3]],
            ['less AND rails', ['file2', 3]]
          ]
        end
      end

      it 'with aditional word' do
        expect_search index, 'ruby', 'AND', 'rails', 'less' do
          [
            ['ruby AND rails', ['file2', 3]],
            ['less', ['file2', 1]]
          ]
        end
      end

      it 'with sentence' do
        expect_search index, 'ruby', 'AND', 'less sass' do
          [
            ['ruby AND less sass', ['file2', 2]]
          ]
        end
      end

      it 'ignore start AND' do
        expect_search index, 'AND', 'rails', 'less' do
          [
            ['rails', ['file4', 4], ['file2', 3]],
            ['less', ['file2', 1]]
          ]
        end
      end

      it 'ignore end AND' do
        expect_search index, 'rails', 'less', 'AND' do
          [
            ['rails', ['file4', 4], ['file2', 3]],
            ['less', ['file2', 1]]
          ]
        end
      end

    end
  end

  def expect_search index, *search_args, &block
    search = described_class.new
    search.instance_variable_set :@current_index, index
    expect(search.send(:do_search, search_args)).to eq(block.call)
  end
end