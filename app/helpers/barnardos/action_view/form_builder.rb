module Barnardos
  module ActionView
    class FormBuilder < ::ActionView::Helpers::FormBuilder
      def labelled_text_field(method, text = nil, text_options: {}, label_options: {}, &block)
        @template.labelled_text_field(
          @object_name, method, text, text_options: text_options,
                                      label_options: label_options, &block
        )
      end
    end
  end
end
