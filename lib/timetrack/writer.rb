# frozen_string_literal: true
module Timetrack
  # Stringify Events in a format suitable for writing to a file
  class Writer
    attr_reader :events

    def initialize(events:)
      @events = events
    end

    def dump
      days.map(&:to_s).join("\n")
    end

    private

    def days
      events
        .group_by { |event| event.begin.to_date }
        .map { |date, events| Day.new date: date, events: events }
    end
  end
end
