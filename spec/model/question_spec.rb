require 'rails_helper'

describe Question do
  describe '#first' do
    it 'starts with the :age questions' do
      expect(Question.first).to eql(:age)
    end
  end

  describe '#next' do
    subject(:next_symbol) { Question.next(current_symbol) }

    context 'it is at the start' do
      let(:current_symbol) { :age }
      it { is_expected.to eql(:name) }
    end

    context 'it is at the end' do
      let(:current_symbol) { :incentive }
      it { is_expected.to be_nil }
    end

    context 'it is not even in the list' do
      let(:current_symbol) { :blah }
      it { is_expected.to be_nil }
    end
  end
end