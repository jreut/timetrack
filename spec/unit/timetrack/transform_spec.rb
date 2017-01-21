# frozen_string_literal: true
require 'spec_helper'
require 'timetrack/transform'

RSpec.describe Timetrack::Transform do
  subject { object.apply(ast) }
  let(:object) { described_class.new }

  context 'time' do
    let(:ast) { { time: '18:24' } }
    specify do
      should eql Timetrack::Transform::UnassociatedTime.new(
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
          begin: double('some beginning time'),
          end: double('some ending time'),
          comment: 'hello'
        }
      }
    end
    specify do
      should eql Timetrack::Transform::UnassociatedEvent.new(
        submitted: true,
        task: ast[:event][:task],
        begin: ast[:event][:begin],
        end: ast[:event][:end],
        comment: ast[:event][:comment]
      )
    end
  end

  context 'date' do
    let(:ast) { { date: '2016/01/21' } }
    specify { should eql Date.new(2016, 1, 21) }
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

    specify do
      should eql Timetrack::Transform::Day.new(
        date: ast[:date],
        events: [
          Timetrack::Transform::Event.new(
            unassociated_event.with(
              begin: Time.new(year, month, day, 10, 22),
              end: Time.new(year, month, day, 14, 0)
            ).to_h
          )
        ]
      )
    end
  end
end
