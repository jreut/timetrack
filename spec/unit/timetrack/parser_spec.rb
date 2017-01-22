# frozen_string_literal: true
RSpec.describe Timetrack::Parser do
  let(:object) { described_class.new }

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
    [
      day_with_events,
      day_without_events,
      day_with_submitted_event
    ].join "\n"
  end

  describe 'task' do
    subject { object.task }
    it { is_expected.to parse '123456' }
  end

  describe 'date' do
    subject { object.date }
    it { is_expected.to parse '2016/01/20' }
    it { is_expected.not_to parse '20/01/2016' }
    it { is_expected.not_to parse '01/20/2016' }
  end

  describe 'time' do
    subject { object.time }
    it { is_expected.to parse '00:00' }
  end

  describe 'comment' do
    subject { object.comment }
    it { is_expected.to parse '; hello there' }
    it { is_expected.to parse ';no space here' }
  end

  describe 'submission_marker' do
    subject { object.submission_marker }
    it { is_expected.to parse '*' }
  end

  describe 'event' do
    subject { object.event }
    it do
      is_expected.to parse '  * 123456  10:00  11:00  ; some thing happened'
    end
    it { is_expected.to parse '  123456  10:00  11:00  ; nothing happened' }
    it { is_expected.to parse '  123456  10:00  11:00   ' }
    it { is_expected.to parse '  123456  10:00    ; this is a neat comment' }
  end

  describe 'event_day' do
    subject { object.event_day }
    it { is_expected.to parse day_with_events }
    it { is_expected.to parse day_without_events }
    it { is_expected.to parse day_with_submitted_event }
  end

  describe 'days' do
    subject { described_class.new.days }
    it { is_expected.to parse days }
  end

  describe 'root' do
    it { is_expected.to parse(days + "\n\n\n") }
  end
end
