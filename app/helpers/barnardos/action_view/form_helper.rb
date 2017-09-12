module Barnardos
  module ActionView
    module FormHelper
      def barnardos_form_with(**options, &block)
        form_with(**options.merge(builder: Barnardos::ActionView::FormBuilder), &block)
      end

      ##
      # <!-- Example HTML output for labelled_text_field_tag :participant_name -->
      # <div class="textfield js-textfield" id="participant_name-wrapper">
      #   <label class="textfield__label" for="participant_name">
      #     What is the name of the research participant?
      #     <span class="textfield__hint">Full name</span>
      #   </label>
      #   <input id="participant_name" class="textfield__input"
      #          name="participant_name" type="text">
      # </div>
      def labelled_text_field(object_name, method, text = nil,
                              text_options: {}, label_options: {}, &block)
        content_tag(
          :div,
          class: 'textfield js-highlight-control', # #{'has-error' if error}",
          id: "#{method}-wrapper"
        ) do
          label_options = label_options.merge(class: "textfield__label #{label_options[:class]}")
          text_options = text_options.merge(
            class: "textfield__input js-highlight-control__input #{text_options[:class]}"
          )

          concat(label(object_name, method, text, label_options, &block))
          if label_options[:hint]
            concat(content_tag(:span, label_options[:hint], class: 'textfield__hint'))
          end
          concat(text_field(object_name, method, text_options))
        end
      end

      def radio_group_vertical(object, method, collection, legend: nil, legend_options: {})
        content_tag :fieldset, class: 'radio-group radio-group__vertical' do
          next unless collection.any?

          # Render a legend for the fieldset, with an optional hint and optional class
          concat(
            content_tag(:legend, class: "radio-group__legend #{legend_options[:class]}") do
              concat(legend)
              if legend_options[:hint]
                concat(content_tag(:span, legend_options[:hint], class: 'radio-group__hint'))
              end
            end
          )

          collection = Array(collection)
          buttons = collection_radio_buttons(
            object, method, collection, :first, :last, include_hidden: false
          ) do |b|
            content_tag :div, class: 'radio-group__choice' do
              b.radio_button(class: 'radio-group__input') +
                b.label(class: 'radio-group__label')
            end
          end

          concat(buttons)
        end
      end
    end
  end
end
