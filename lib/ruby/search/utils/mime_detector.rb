require 'filemagic'

module Ruby
  module Search
    module Utils

      module MimeDetector
        def text_file?(filename)
          begin fm = FileMagic.new(FileMagic::MAGIC_MIME)
            fm.file(filename) =~ /^text\//
          ensure
            fm.close
          end
        end
      end

    end
  end
end