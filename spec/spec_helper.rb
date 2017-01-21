# frozen_string_literal: true
require 'rspec/snapshot'

module Helpers
  def fixture_file(filename)
    fixture_path = Pathname.pwd.join 'spec/fixtures/files'
    file_path = fixture_path.join filename
    File.open file_path, 'r'
  end
end

RSpec.configure do |config|
  config.include Helpers
  config.snapshot_dir = 'spec/fixtures/snapshots'

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.filter_run_when_matching :focus
  config.example_status_persistence_file_path = 'spec/examples.txt'
  config.disable_monkey_patching!
  config.warnings = true
  config.default_formatter = 'doc' if config.files_to_run.one?
  config.profile_examples = 10
  config.order = :random

  Kernel.srand config.seed
end
