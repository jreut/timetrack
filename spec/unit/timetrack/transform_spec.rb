# frozen_string_literal: true
RSpec.describe Timetrack::Transform do
  subject { object.apply(ast) }
  let(:object) { described_class.new }

  context 'time' do
    let(:ast) { { time: '18:24' } }
    specify do
      is_expected.to eql Timetrack::Transform::UnassociatedTime.new(
        hour: 18,
        minute: 24
      )
    end
  end

  context 'event' do
    let(:ast) do
      {
        event: {
          submitted: '*',
          task: '098765',
          begin: instance_double(Hash),
          end: instance_double(Hash),
          comment: 'hello'
        }
      }
    end
    let(:expected) do
      Timetrack::Transform::UnassociatedEvent.new(
        submitted: true,
        task: ast[:event][:task],
        begin: ast[:event][:begin],
        end: ast[:event][:end],
        comment: ast[:event][:comment]
      )
    end

    specify { is_expected.to eql expected }
  end

  context 'date' do
    let(:ast) { { date: '2016/01/21' } }
    specify { is_expected.to eql Date.new(2016, 1, 21) }
  end

  context 'day' do
    let(:year) { 2016 }
    let(:month) { 12 }
    let(:day) { 23 }
    let(:unassociated_event) do
      Timetrack::Transform::UnassociatedEvent.new(
        submitted: false,
        task: '517503',
        begin: Timetrack::Transform::UnassociatedTime.new(hour: 10, minute: 22),
        end: Timetrack::Transform::UnassociatedTime.new(hour: 14, minute: 0),
        comment: 'hello, there'
      )
    end
    let(:ast) do
      {
        date: Date.new(year, month, day),
        events: [unassociated_event]
      }
    end
    let(:expected) do
      [
        Timetrack::Event.new(
          unassociated_event.with(
            begin: Time.new(year, month, day, 10, 22),
            end: Time.new(year, month, day, 14, 0)
          ).to_h
        )
      ]
    end

    specify { is_expected.to eql expected }
  end
end
