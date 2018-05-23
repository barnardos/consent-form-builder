# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HasAtLeastOneValidator, type: :validator do
  ALLOWABLE_INGREDIENTS = %i[bacon eggs beans].freeze

  class Breakfast < Struct.new(:ingredients)
    include ActiveModel::Validations

    validates :ingredients, has_at_least_one: { of: ALLOWABLE_INGREDIENTS }
  end

  subject(:breakfast) { Breakfast.new }
  let(:ingredient_errors) { breakfast.errors.messages[:ingredients] }

  before do
    breakfast.ingredients = ingredients
    breakfast.valid?
  end

  context 'Our breakfast has nil ingredients' do
    let(:ingredients) { nil }

    it { is_expected.to be_invalid }
    it 'has an error' do
      expect(ingredient_errors.length).to eql(1)
      expect(ingredient_errors.first).to \
        eql('should have at least one of bacon, eggs, or beans')
    end
  end

  context 'Our breakfast has no ingredients' do
    let(:ingredients) { [] }

    it { is_expected.to be_invalid }
    it 'has an error' do
      expect(ingredient_errors.length).to eql(1)
      expect(ingredient_errors.first).to \
        eql('should have at least one of bacon, eggs, or beans')
    end
  end

  context 'Our ingredients are not an array (non-human error)' do
    let(:ingredients) { :'A single hash brown' }

    it { is_expected.to be_invalid }
    it 'has an error' do
      expect(ingredient_errors.length).to eql(1)
      expect(ingredient_errors.first).to \
        eql('should be an enumerable')
    end
  end

  context 'Our breakfast has valid ingredients' do
    let(:ingredients) { %i[bacon eggs] }

    it { is_expected.to be_valid }
  end

  context 'Our validator hates mushrooms and tomatoes' do
    let(:ingredients) { [:bacon, :eggs, :mushrooms, 'tomatoes'] }

    it { is_expected.not_to be_valid }

    it 'indicates what is unpalatable in human-digestible form' do
      expect(ingredient_errors.length).to eql(1)
      expect(ingredient_errors.first).to \
        eql('has these invalid values: mushrooms and tomatoes')
    end
  end

  context 'Our validator hates mushrooms and tomatoes' do
    let(:ingredients) { [:bacon, :eggs, :mushrooms, :black_pudding, 'tomatoes'] }

    it { is_expected.not_to be_valid }

    it 'indicates what is unpalatable in human-digestible form' do
      expect(ingredient_errors.length).to eql(1)
      expect(ingredient_errors.first).to \
        eql('has these invalid values: mushrooms, black pudding, and tomatoes')
    end
  end
end
