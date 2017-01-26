module Ruby
  module Search
    class IndexedFile
      attr_accessor :name, :errors

      def initialize name = nil
        @name = name
        @errors = []
      end

      def valid?
        if name
          errors << "File #{name} does not exists" unless File.exist?(name)
        else
          errors << 'No file path passed'
        end
        @errors.blank?
      end

      def index
        hash_view extract_tokens IO.read name
      end

      private

      def extract_tokens text
        text.split(/\W+/)
        # tokens = arr.length.times.map{|i| arr.length.times.map{|j| arr[i..j].join(' ') unless i > j}}.flatten.compact
      end

      def hash_view arr
        arr.inject({}){|h, s| h[s] ||= {name => 0}; h[s][name] += 1; h }
      end
    end
  end
end