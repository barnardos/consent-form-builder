##
#
# Usage:
#
#   validates :ingredients, has_at_least_one: { of: [:bacon, :eggs, :beans] }
class HasAtLeastOneValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, values)
    valid_values = options[:of]

    if values.blank?
      record.errors[attribute] << "#{attribute} should have at least one of #{valid_values}"
      return
    end

    invalid_values_found = values.inject([]) do |found, value|
      current_value = value.to_sym
      found << current_value unless valid_values.include?(current_value)
      found
    end

    record.errors[attribute] << \
      "#{attribute} has these invalid values: #{invalid_values_found}" if invalid_values_found.any?
  end
end
