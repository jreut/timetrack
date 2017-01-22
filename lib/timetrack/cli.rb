# frozen_string_literal: true
require 'thor'
require 'timetrack'

module Timetrack
  # Command-line interface to this gem
  # :reek:UtilityFunction
  class CLI < Thor
    class_option :file, type: :string, required: true

    desc 'last', 'Print the latest chronological event'
    option :porcelain, type: :boolean
    def last
      puts Runtime.new(file: options[:file]).most_recent_event
    end
  end
end
