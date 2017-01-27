require "spec_helper"

RSpec.describe Ruby::Search do
  it 'check index without args' do
    setup_aruba
    run "bin/index"

    stop_all_commands
    expect(last_command_started.output).to eq("No file path passed\n")
  end
end
