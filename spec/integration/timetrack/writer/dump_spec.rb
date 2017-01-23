# frozen_string_literal: true
RSpec.describe Timetrack::Writer, '#dump' do
  let(:writer) { described_class.new events: events }

  context 'a single event' do
    let(:events) { [event] }
    let(:event) do
      Timetrack::Event.new(
        submitted: true,
        begin: Time.new(2031, 11, 6, 7, 19),
        end: Time.new(2031, 11, 6, 8, 0),
        task: '401840',
        comment: 'no comment'
      )
    end
    let(:expected) do
      "2031/11/06\n  * 401840  07:19  08:00  ; no comment"
    end

    it 'writes the date and pertinent details' do
      expect(writer.dump).to eql expected
    end
  end
end
