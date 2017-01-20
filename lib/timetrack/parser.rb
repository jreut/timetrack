# frozen_string_literal: true
require 'parslet'

module Timetrack
  # Read an IO and parse it into an AST
  class Parser < Parslet::Parser
    rule(:task) { match('\d').repeat 6 }
    rule(:year) { match['\d'].repeat 4 }
    rule(:month) { match['\d'].repeat 2 }
    rule(:day) { match['\d'].repeat 2 }
    rule(:date) { year >> str('/') >> month >> str('/') >> day }
    rule(:hour) { match['\d'].repeat 2 }
    rule(:minute) { match['\d'].repeat 2 }
    rule(:time) { hour >> str(':') >> minute }
  end
end
