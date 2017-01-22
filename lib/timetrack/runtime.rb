# frozen_string_literal: true
module Timetrack
  # Entrypoint for executable
  class Runtime
    attr_reader :file

    def initialize(file:)
      @file = File.open file, 'r'
    end

    def most_recent_event
      file.readlines.last
    end
  end
end
