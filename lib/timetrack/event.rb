# frozen_string_literal: true
module Timetrack
  # Value object for an event that has its date information
  class Event
    include Anima.new :submitted, :task, :begin, :end, :comment
  end
end
