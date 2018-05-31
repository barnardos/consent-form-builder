class PaymentType
  CHOICES = [
    {
      id: 'cash',
      value: 'cash',
      label: 'Cash' 
    },
    {
      id: 'voucher',
      value: 'voucher',
      label: 'High street shopping voucher'
    }
  ].freeze

  def self.allowed_values
    CHOICES.map { |choice| choice[:value] }
  end
end
