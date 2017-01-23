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

  context 'multiple events on the same date' do
    let(:events) { [first_event, second_event] }
    let(:date) { Date.new(1985, 11, 15) }
    let(:first_event) do
      Timetrack::Event.new(
        submitted: true,
        begin: Time.new(date.year, date.month, date.day, 11, 45),
        end: Time.new(date.year, date.month, date.day, 12, 0),
        task: '018312',
        comment: 'set up the clocktower'
      )
    end
    let(:second_event) do
      Timetrack::Event.new(
        submitted: false,
        begin: Time.new(date.year, date.month, date.day, 22, 0),
        end: Time.new(date.year, date.month, date.day, 22, 1),
        task: '018313',
        comment: 'accelerate to 88 mph'
      )
    end
    let(:expected) do
      <<-OUTPUT.chomp
1985/11/15
  * 018312  11:45  12:00  ; set up the clocktower
  018313  22:00  22:01  ; accelerate to 88 mph
      OUTPUT
    end

    it 'writes the events under a single date heading' do
      expect(writer.dump).to eql expected
    end
  end

  context 'multiple events on different dates' do
    let(:events) { [first_event, second_event] }
    let(:first_event) do
      Timetrack::Event.new(
        submitted: true,
        begin: Time.new(1901, 2, 4, 9, 10),
        end: Time.new(1901, 2, 4, 13, 0),
        task: '647752',
        comment: ''
      )
    end
    let(:second_event) do
      Timetrack::Event.new(
        submitted: true,
        begin: Time.new(1901, 2, 5, 8, 56),
        end: Time.new(1901, 2, 5, 10, 7),
        task: '371058',
        comment: ''
      )
    end
    let(:expected) do
      <<-OUTPUT.chomp
1901/02/04
  * 647752  09:10  13:00

1901/02/05
  * 371058  08:56  10:07
      OUTPUT
    end

    it 'writes events under separate headers for each date' do
      expect(writer.dump).to eql expected
    end
  end
end
