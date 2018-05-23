# frozen_string_literal: true

##
#
# Usage:
#
#   validates :ingredients, has_at_least_one: { of: [:bacon, :eggs, :beans] }
class HasAtLeastOneValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, values)
    valid_values = options[:of]

    return if no_values(record, attribute, values, valid_values)

    return unless enumerable?(record, attribute, values)

    invalid_values_found = values.each_with_object([]) do |value, found|
      found << value.to_s.humanize(capitalize: false) unless valid_values.include?(value.to_sym)
    end

    set_invalid_values(record, attribute, invalid_values_found)
  end

  private

  def no_values(record, attribute, values, valid_values)
    if values.blank?
      record.errors[attribute] << 'should have at least one of '\
        "#{valid_values.to_sentence(last_word_connector: ', or ')}"
      true
    else
      false
    end
  end

  def enumerable?(record, attribute, values)
    if values.respond_to?(:each)
      true
    else
      record.errors[attribute] << 'should be an enumerable'
      false
    end
  end

  def set_invalid_values(record, attribute, invalid_values_found)
    return if invalid_values_found.empty?
    record.errors[attribute] << \
      'has these invalid values: '\
      "#{invalid_values_found.to_sentence}"
  end
end
