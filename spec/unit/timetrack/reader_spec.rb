# frozen_string_literal: true
RSpec.describe Timetrack::Reader do
  let(:reader) do
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
  let(:parsed) { instance_double Hash }

  before do
    allow(input).to receive(:read).with(no_args).and_return(string)
    allow(parser).to receive(:parse).with(string).and_return(parsed)
    allow(transform).to receive(:apply).with(parsed)
  end

  context '#load' do
    before do
      reader.load
    end

    it 'calls input#read' do
      expect(input).to have_received(:read).with no_args
    end

    it 'calls parser#parse with the value of input#read' do
      expect(parser).to have_received(:parse).with input.read
    end

    it 'calls transform#apply with the value of parser#parse' do
      expect(transform).to have_received(:apply).with parsed
    end
  end
end
