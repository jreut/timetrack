# frozen_string_literal: true
require 'anima'

module Timetrack
  # Assemble a parser, a transform, and an IO-like object together to turn them
  # into an AST.
  class Reader
    include Anima.new :input, :parser, :transform

    def load
      transform.apply parser.parse input.read
    end
  end
end
