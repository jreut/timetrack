# frozen_string_literal: true
module Timetrack
  # Collection of events for a single day
  class Day
    include Anima.new :date, :events

    def to_s
      "#{date_string}\n#{events.join("\n")}"
    end

    private

    def date_string
      format '%04d/%02d/%02d', date.year, date.month, date.day
    end
  end
end
