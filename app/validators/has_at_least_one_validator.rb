# frozen_string_literal: true

##
#
# Usage:
#
#   validates :ingredients, has_at_least_one: { of: [:bacon, :eggs, :beans] }
class HasAtLeastOneValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, values)
    valid_values = options[:of]

    if values.blank?
      record.errors[attribute] << 'should have at least one of '\
        "#{valid_values.to_sentence(last_word_connector: ', or ')}"
      return
    end

    unless values.respond_to?(:each)
      record.errors[attribute] << 'should be an enumerable'
      return
    end

    invalid_values_found = values.each_with_object([]) do |value, found|
      found << value.to_s.humanize(capitalize: false) unless valid_values.include?(value.to_sym)
    end

    if invalid_values_found.any?
      record.errors[attribute] << \
        'has these invalid values: '\
        "#{invalid_values_found.to_sentence}"
    end
  end
end
