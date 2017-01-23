# frozen_string_literal: true
require 'ostruct'

RSpec.describe Timetrack::Event do
  let(:object) { described_class.new attributes }

  describe '#to_s' do
    subject { object.to_s }
    let(:submitted) { true }
    let(:task) { '103483' }
    let(:begin) { OpenStruct.new hour: 15, min: 23 }
    let(:end) { OpenStruct.new hour: 18, min: 0 }
    let(:comment) { 'remarkable' }
    let(:attributes) do
      {
        submitted: submitted,
        task: task,
        begin: self.begin,
        end: self.end,
        comment: comment
      }
    end

    context 'a completely annotated event' do
      it { is_expected.to eql '  * 103483  15:23  18:00  ; remarkable' }
    end

    context 'an event without comment' do
      let(:comment) { nil }
      it { is_expected.to eql '  * 103483  15:23  18:00' }
    end

    context 'an unsubmitted event' do
      let(:submitted) { false }
      it { is_expected.to eql '  103483  15:23  18:00  ; remarkable' }
    end
  end
end
