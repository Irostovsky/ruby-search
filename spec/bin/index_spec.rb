require "spec_helper"

RSpec.describe Ruby::Search do
  describe '#index' do

    it 'check index without args' do
      setup_aruba
      run "bin/index"

      stop_all_commands
      expect(last_command_started.output).to eq("No file path passed\n")
    end

    it 'check index text file' do
      setup_aruba
      run "bin/index ../../spec/tmp/file1.txt"

      stop_all_commands
      expect(last_command_started.output).to eq("Updated index: index.yml\n")
    end

  end
end
