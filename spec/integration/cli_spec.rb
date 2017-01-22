# frozen_string_literal: true
require 'spec_helper'
require 'timetrack/cli'

RSpec.describe Timetrack::CLI do
  describe 'last' do
    context '--porcelain' do
      let(:file) { fixture_file('simple_document.txt').path }
      it 'displays information in a machine-parseable fashion' do
        sys_exec "timetrack last --file=#{file} --porcelain"
        expected = "d\x312016/01/19\x32t\x31205897\x32" \
                 "b\x3116:30\x32e\x32c\x31plan next tasks"
        expect(err).to be_empty
        expect(out).to eql expected
      end
    end
  end
end
