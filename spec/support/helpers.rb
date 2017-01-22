# frozen_string_literal: true
require 'open3'

module Spec
  # spec helpers
  module Helpers
    attr_reader :out, :err, :exitstatus

    # adapted from https://github.com/bundler/bundler/blob/915806bb762a7f1ebf0d55caa2d7833c940608c5/spec/support/helpers.rb#L165-L184
    # :reek:TooManyStatements
    # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    def sys_exec(cmd)
      cmd_string = cmd.to_s
      Open3.popen3(cmd_string) do |stdin, stdout, stderr, wait_thr|
        yield stdin, stdout, wait_thr if block_given?
        stdin.close

        @exitstatus = wait_thr && wait_thr.value.exitstatus
        @out = Thread.new { stdout.read }.value.strip
        @err = Thread.new { stderr.read }.value.strip
      end

      output = [
        "$ #{cmd_string.strip}",
        out,
        err,
        @exitstatus ? "# $? => #{@exitstatus}" : '',
        "\n"
      ].reject(&:empty?).join("\n")

      @all_output ||= ''
      @all_output += output

      @out
    end
    # rubocop:enable Metrics/AbcSize

    # :reek:UtilityFunction
    def fixture_file(filename)
      fixture_path = Pathname.pwd.join 'spec/fixtures/files'
      file_path = fixture_path.join filename
      File.open file_path, 'r'
    end
  end
end
