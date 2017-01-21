# frozen_string_literal: true
require 'parslet'

module Timetrack
  # Read an IO and parse it into an AST
  class Parser < Parslet::Parser
    rule(:eof) { any.absent? }
    rule(:newline) { match['\n'] }
    rule(:space) { str ' ' }
    rule(:gutter) { space.repeat(2) }
    rule(:to_eol) { match['^\n'].repeat }
    rule(:task) { match('\d').repeat 6 }
    rule(:year) { match['\d'].repeat 4 }
    rule(:month) { match['\d'].repeat 2 }
    rule(:day) { match['\d'].repeat 2 }
    rule(:date) { year >> str('/') >> month >> str('/') >> day }
    rule(:hour) { match['\d'].repeat 2 }
    rule(:minute) { match['\d'].repeat 2 }
    rule(:time) { hour >> str(':') >> minute }
    rule(:text) { match['[^\n]'].repeat }
    rule(:comment) { str(';') >> match['\s'].repeat >> text }
    rule(:submission_marker) { str '*' }
    rule(:submission_block) { submission_marker >> space }
    rule(:event) do
      gutter >>
        submission_block.maybe >>
        task >>
        gutter >> time >>
        (gutter >> time).maybe >>
        (gutter >> comment).maybe >>
        to_eol
    end
    rule(:events) { (event >> newline).repeat }
    rule(:event_day) do
      (date >> newline) >>
      events
    end
    rule(:days) do
      (event_day >> newline).repeat >> event_day.maybe
    end
    rule(:document) do
      days >> newline.repeat >> eof
    end

    root :document
  end
end
