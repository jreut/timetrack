# frozen_string_literal: true
require 'spec_helper'
require 'parslet/rig/rspec'
require 'timetrack/parser'

RSpec.describe Timetrack::Parser do
  subject { described_class.new }

  let(:day_with_events) do
    <<END
2016/01/20
  123456  10:00  11:00  ; that's one small
  098765  11:00  14:30  ; step for man,
  499123  14:45  15:00  ; one giant leap
  100493  15:00  ; for mankind
END
  end

  let(:day_without_events) do
    <<END
2016/01/21
END
  end

  let(:day_with_submitted_event) do
    <<END
2016/01/22
  * 363913  09:00  09:01
END
  end

  let(:days) do
    [day_with_events, day_without_events, day_with_submitted_event].join("\n")
  end

  describe 'task' do
    it 'should consume a six-digit number' do
      expect(subject.task).to parse '123456'
    end
  end

  describe 'date' do
    it 'should consume a YYYY/MM/DD string' do
      expect(subject.date).to parse '2016/01/20'
    end

    it 'should reject a DD/MM/YYYY string' do
      expect(subject.date).not_to parse '20/01/2016'
    end

    it 'should reject a MM/DD/YYYY string' do
      expect(subject.date).not_to parse '01/20/2016'
    end
  end

  describe 'time' do
    it 'should consume a HH:MM string' do
      expect(subject.time).to parse '00:00'
    end
  end

  describe 'comment' do
    it 'should consume a comment string' do
      expect(subject.comment).to parse '; hello there'
    end

    it 'should consume a comment string without a leading space' do
      expect(subject.comment).to parse ';no space here'
    end
  end

  describe 'submission_marker' do
    it 'should consume an asterisk' do
      expect(subject.submission_marker).to parse '*'
    end
  end

  describe 'event' do
    it 'should consume a submitted event' do
      expect(subject.event).to parse '  * 123456  10:00  11:00  ; some thing happened'
    end

    it 'should consume an unsubmitted event' do
      expect(subject.event).to parse '  123456  10:00  11:00  ; nothing happened'
    end

    it 'should consume an event with no comment and trailing whitespace' do
      expect(subject.event).to parse '  123456  10:00  11:00   '
    end

    it 'should consume an event with a comment and no ending time' do
      expect(subject.event).to parse '  123456  10:00    ; this is a neat comment'
    end
  end

  describe 'event_day' do
    it 'should consume a day with unusubmitted events' do
      expect(subject.event_day).to parse day_with_events
    end

    it 'should consume a day with no events' do
      expect(subject.event_day).to parse day_without_events
    end

    it 'should consume a day with a submitted event' do
      expect(subject.event_day).to parse day_with_submitted_event
    end
  end

  describe 'days' do
    it 'should consume several days' do
      expect(subject.days).to parse days
    end
  end

  describe 'root' do
    it 'should consume a several days, optionally followed by blank lines' do
      expect(subject).to parse(days + "\n\n\n")
    end
  end
end
