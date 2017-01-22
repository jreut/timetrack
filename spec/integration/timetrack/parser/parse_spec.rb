# frozen_string_literal: true
RSpec.describe Timetrack::Parser, '#parse' do
  let(:object) { described_class.new }

  context 'a simple document' do
    subject { object.parse(fixture_file('simple_document.txt').read).to_s }
    it 'matches its snapshot' do
      is_expected.to match_snapshot('parsed_simple_document')
    end
  end
end
