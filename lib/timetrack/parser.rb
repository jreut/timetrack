# frozen_string_literal: true
module Timetrack
  # Read an IO and parse it into an AST
  class Parser < Parslet::Parser
    rule(:eof) { any.absent? }
    rule(:newline) { match['\n'] }
    rule(:space) { str ' ' }
    rule(:gutter) { space.repeat(2) }
    rule(:to_eol) { match['^\n'].repeat }
    rule(:task) { match('\d').repeat(6).as(:task) }
    rule(:year) { match['\d'].repeat 4 }
    rule(:month) { match['\d'].repeat 2 }
    rule(:day) { match['\d'].repeat 2 }
    rule(:date) { year >> str('/') >> month >> str('/') >> day }
    rule(:hour) { match['\d'].repeat 2 }
    rule(:minute) { match['\d'].repeat 2 }
    rule(:time) { (hour >> str(':') >> minute).as(:time) }
    rule(:begin_time) { (gutter >> time.as(:begin)) }
    rule(:end_time) { (gutter >> time.as(:end)).maybe }
    rule(:times) { begin_time >> end_time }
    rule(:text) { match['[^\n]'].repeat }
    rule(:comment) { str(';') >> match['\s'].repeat >> text.as(:comment) }
    rule(:comment_block) { (gutter >> comment).maybe }
    rule(:submission_marker) { str('*').as(:submitted) }
    rule(:submission_block) { (submission_marker >> space).maybe }
    rule(:event) do
      gutter >> submission_block >> task >> times >> comment_block >> to_eol
    end
    rule(:events) { (event.as(:event) >> newline).repeat }
    rule(:event_day) { date.as(:date) >> newline >> events.as(:events) }
    rule(:days) do
      (event_day >> newline.repeat).repeat
    end
    rule(:document) { days >> newline.repeat >> eof }
    root :document
  end
end
