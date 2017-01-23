# frozen_string_literal: true
module Timetrack
  # Format a Time as HH:MM
  class TimeFormatter
    def self.format(time)
      Kernel.format '%02d:%02d', time.hour, time.min
    end
  end
end
