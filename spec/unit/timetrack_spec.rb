# frozen_string_literal: true
require 'spec_helper'

RSpec.describe Timetrack do
  it 'has a version number' do
    expect(Timetrack::VERSION).not_to be nil
  end
end
