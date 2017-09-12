module Barnardos
  module ActionView
    class FormBuilder < ::ActionView::Helpers::FormBuilder
      def labelled_text_field(method, text = nil, text_options: {}, label_options: {}, &block)
        @template.labelled_text_field(
          @object_name, method, text, text_options: text_options,
                                      label_options: label_options, &block
        )
      end

      def labelled_text_area(method, label: nil, label_options: {}, text_options: {})
        @template.labelled_text_area(
          @object_name, method, label: label,
                                label_options: label_options, text_options: text_options
        )
      end

      def radio_group_vertical(method, collection, legend: nil, legend_options: {})
        @template.radio_group_vertical(
          @object_name, method, collection, legend: legend, legend_options: legend_options
        )
      end
    end
  end
end