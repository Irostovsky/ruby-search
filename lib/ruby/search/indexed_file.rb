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

    end
  end
end