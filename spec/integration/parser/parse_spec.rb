# frozen_string_literal: true
require 'spec_helper'
require 'timetrack'

RSpec.describe Timetrack::Parser, '#parse' do
  let(:object) { described_class.new }

  context 'a simple document' do
    subject { object.parse(fixture_file('simple_document.txt').read).to_s }
    it 'parses to the expected AST' do
      should match_snapshot('parsed_simple_document')
    end
  end
end
