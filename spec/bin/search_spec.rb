require "spec_helper"

RSpec.describe Ruby::Search do
  describe '#search' do

    it 'check index without args' do
      setup_aruba
      run "bin/search"

      stop_all_commands
      expect(last_command_started.output).to eq("No search keywords passed\n")
    end

    it 'check search' do
      setup_aruba
      run "bin/index ../../spec/tmp/file1.txt"
      sleep(1)
      run "bin/search document"

      stop_all_commands
      expect(last_command_started.output).to eq("\n1. Searching for 'document' ...\n   Found in:\n        ../../spec/tmp/file1.txt : 2\n")
    end

  end
end
