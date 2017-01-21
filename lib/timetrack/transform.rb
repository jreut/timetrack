# frozen_string_literal: true
require 'parslet'
require 'anima'

module Timetrack
  # Transform a deeply-nested hash into a rich object graph
  class Transform < Parslet::Transform
    def self.parse_time(string)
      hour, minute = string.split(':').map(&:to_i)
      UnassociatedTime.new hour: hour, minute: minute
    end

    rule(time: simple(:time)) { |bind| parse_time bind[:time] }
    rule(event: subtree(:event)) do
      UnassociatedEvent.new(event).with submitted: !event[:submitted].empty?
    end
    rule(date: simple(:date)) { Date.parse date }
    rule(date: simple(:date), events: sequence(:events)) do
      Day.new(
        date: date,
        events: events.map do |unassociated_event|
          unassociated_event.to_event date
        end
      )
    end

    # Intermediate event representation before it's been associated with a date
    class UnassociatedEvent
      include Anima.new :submitted, :task, :begin, :end, :comment

      def to_event(date)
        Event.new(
          with(
            begin: self.begin.to_time(date),
            end: self.end.to_time(date)
          ).to_h
        )
      end
    end

    # Intermediate time representation before it's been associated with a date
    class UnassociatedTime
      include Anima.new :hour, :minute

      # This method smells of :reek:FeatureEnvy
      def to_time(date)
        Time.new date.year, date.month, date.day, hour, minute
      end
    end

    # Value object for an event that has its date information
    class Event
      include Anima.new :submitted, :task, :begin, :end, :comment
    end

    # Value object for a day and its events
    class Day
      include Anima.new :date, :events
    end
  end
end
