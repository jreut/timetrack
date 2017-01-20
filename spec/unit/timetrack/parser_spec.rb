# frozen_string_literal: true
require 'spec_helper'
require 'parslet/rig/rspec'
require 'timetrack/parser'

RSpec.describe Timetrack::Parser do
  subject { described_class.new }

  describe 'task' do
    it 'should consume a six-digit number' do
      expect(subject.task).to parse '123456'
    end
  end

  describe 'date' do
    it 'should consume a YYYY/MM/DD string' do
      expect(subject.date).to parse '2016/01/20'
    end

    it 'should reject a YYYY/DD/MM string' do
      pending 'validate date ranges'
      expect(subject.date).not_to parse '2016/20/01'
    end

    it 'should reject a DD/MM/YYYY string' do
      expect(subject.date).not_to parse '20/01/2016'
    end

    it 'should reject a MM/DD/YYYY string' do
      expect(subject.date).not_to parse '01/20/2016'
    end
  end

  describe 'time' do
    it 'should consume a HH:MM string' do
      expect(subject.time).to parse '00:00'
    end
  end
end
