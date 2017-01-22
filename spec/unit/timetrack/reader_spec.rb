# frozen_string_literal: true
RSpec.describe Timetrack::Reader do
  subject do
    described_class.new(
      parser: parser,
      transform: transform,
      input: input
    )
  end
  let(:parser) { instance_double Timetrack::Parser }
  let(:transform) { instance_double Timetrack::Transform }
  let(:input) { instance_double IO }
  let(:string) { instance_double String }
  let(:parsed) { double('parsed data structure') }

  before do
    allow(input).to receive(:read).with(no_args).and_return(string)
    allow(parser).to receive(:parse).with(string).and_return(parsed)
    allow(transform).to receive(:apply).with(parsed)
  end

  context '#load' do
    after do
      subject.load
    end

    it 'should call input#read' do
      expect(input).to receive(:read).with no_args
    end

    it 'should call parser#parse with the value of input#read' do
      expect(parser).to receive(:parse).with input.read
    end

    it 'should call transform#apply with the value of parser#parse' do
      expect(transform).to receive(:apply).with parsed
    end
  end
end
