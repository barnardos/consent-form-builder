module Barnardos
  module ActionView
    module FormHelper
      def barnardos_form_with(**options, &block)
        form_with(**options.merge(builder: Barnardos::ActionView::FormBuilder), &block)
      end
    end
  end
end
