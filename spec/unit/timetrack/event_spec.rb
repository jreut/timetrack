# frozen_string_literal: true
RSpec.describe Timetrack::Event do
  let(:object) { described_class.new attributes }

  describe '#to_s' do
    subject { object.to_s }

    context 'a completely annotated event' do
      let(:attributes) do
        {
          submitted: true,
          task: '103483',
          begin: Time.parse('15:23'),
          end: Time.parse('18:00'),
          comment: 'remarkable'
        }
      end

      it { is_expected.to eql '  * 103483  15:23  18:00  ; remarkable' }
    end
  end
end
