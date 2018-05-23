# frozen_string_literal: true

class PaymentType
  NAME_VALUES = HashWithIndifferentAccess[{
    cash:    'Cash',
    voucher: 'High street shopping voucher'
  }]

  def self.allowed_values
    NAME_VALUES.keys.map(&:to_s)
  end
end
