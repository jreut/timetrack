# frozen_string_literal: true
module Timetrack
  # Value object for an event that has its date information
  class Event
    include Anima.new :submitted, :task, :begin, :end, :comment

    def to_s
      "  #{submitted_block}#{task}  #{TimeFormatter.format self.begin}" \
        "  #{TimeFormatter.format self.end}#{comment_block}"
    end

    private

    def spaces
      '  '
    end

    def submitted_block
      submitted ? '* ' : ''
    end

    def comment_block
      comment.empty? ? '' : "  ; #{comment}"
    end
  end
end
