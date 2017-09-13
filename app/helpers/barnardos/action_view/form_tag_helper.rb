module Barnardos
  module ActionView
    module FormTagHelper
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
      def labelled_text_field_tag(name, label, value = nil, error: nil,
                                  text_options: {}, label_options: {})
        content_tag :div,
                    class: "textfield js-highlight-control #{'has-error' if error}",
                    id: "#{name}-wrapper" do
          concat(
            label_tag(name, class: "textfield__label #{label_options[:class]}") do
              concat(label)
              if label_options[:hint]
                concat(content_tag(:span, label_options[:hint], class: 'textfield__hint'))
              end
            end
          )
          concat(
            text_field_tag(
              name,
              value,
              text_options.reverse_merge(class: 'textfield__input js-highlight-control__input')
            )
          )
          concat(content_tag(:div, error, class: 'textfield__error')) if error
        end
      end

      ##
      # <!-- Example HTML output for labelled_textarea_field_tag :participant_description -->
      # <div class="textarea js-textarea" id="participant_description-wrapper">
      #   <label class="textarea__label" for="participant_description">
      #     Describe the resaerch participant?
      #     <span class="textarea__hint">Height, experience, mood</span>
      #   </label>
      #   <textarea id="participant_description"
      #             class="textarea__input" name="participant_description"></textarea>
      # </div>
      def labelled_text_area_tag(name, label, value = nil, error: nil,
                                 text_options: {}, label_options: {})
        content_tag :div,
                    class: "textarea js-highlight-control #{'has-error' if error}",
                    id: "#{name}-wrapper" do
          concat(
            label_tag(name, class: "textarea__label #{label_options[:class]}") do
              concat(label)
              if label_options[:hint]
                concat(content_tag(:span, label_options[:hint], class: 'textarea__hint'))
              end
            end
          )

          textarea_options = text_options.reverse_merge(
            class: 'textarea__input js-highlight-control__input',
            rows: '4'
          )

          concat(text_area_tag(name, value, textarea_options))
          concat(content_tag(:div, error, class: 'textarea__error')) if error
        end
      end

      ##
      # <!-- Example HTML output for:
      #    radio_group_vertical :age, 'This is a cool legend', [['under12', 'Under 12 years old']]
      #    or
      #    radio_group_vertical :age, 'No one will see this',
      #     {'under12' => 'Under 12 years old'}, legend_options: { class: 'visually-hidden' } -->
      #
      # Legend options include class and hint
      #
      # <fieldset class="radio-group radio-group__vertical">
      #   <legend class="radio-group__legend">
      #     Some big legend
      #     <span class="radio-group__hint">Some more help for the label</span>
      #   </legend>
      #
      #   <div class="radio-group__choice">
      #     <input class="radio-group__input" id="age-under12" type="radio" name="age"
      #       value="under12">
      #     <label class="radio-group__label" for="age-under12">Under 12 years old</label>
      #   </div>
      # </fieldset>
      def radio_group_vertical_tag(
        name, legend, selection_list,
        value = nil, error: nil, legend_options: {}
      )
        content_tag :fieldset, class: "radio-group radio-group__vertical #{'has-error' if error}" do
          # Only render markup if there are options to show
          if selection_list.present?

            # Render a legend for the fieldset, with an optional hint and optional class
            concat(
              content_tag(:legend, class: "radio-group__legend #{legend_options[:class]}") do
                concat(legend)
                if legend_options[:hint]
                  concat(content_tag(:span, legend_options[:hint], class: 'radio-group__hint'))
                end
              end
            )

            # Render radio options
            selection_list.each do |selection_item_value, selection_item_text|
              id = "#{name}-#{selection_item_value}"
              checked = value.eql?(selection_item_value)
              concat(
                content_tag(:div, class: 'radio-group__choice') do
                  concat(
                    radio_button_tag(
                      name,
                      selection_item_value,
                      checked,
                      class: 'radio-group__input',
                      id: id
                    )
                  )
                  concat(
                    label_tag(name, selection_item_text, class: 'radio-group__label', for: id)
                  )
                end
              )
            end
          end
        end
      end

      def checkbox_group_vertical_tag(name, legend, selection_list, values = [],
                                      error: nil, legend_options: {})
        values = values&.map(&:to_s)

        content_tag(
          :fieldset,
          class: "checkbox-group checkbox-group__vertical #{'has-error' if error}"
        ) do
          # Only render markup if there are options to show
          if selection_list.present?

            # Render a legend for the fieldset, with an optional hint and optional class
            concat(
              content_tag(:legend, class: "checkbox-group__legend #{legend_options[:class]}") do
                concat(legend)
                if legend_options[:hint]
                  concat(content_tag(:span, legend_options[:hint], class: 'checkbox-group__hint'))
                end
              end
            )

            # Render checkbox options
            selection_list.each do |selection_item_value, selection_item_text|
              id = "#{name}-#{selection_item_value}"
              checked = values&.include?(selection_item_value.to_s)
              concat(
                content_tag(:div, class: 'checkbox-group__choice') do
                  concat(
                    check_box_tag(
                      name, selection_item_value,
                      checked, class: 'checkbox-group__input', id: id
                    )
                  )
                  concat(
                    label_tag(name, selection_item_text, class: 'checkbox-group__label', for: id)
                  )
                end
              )
            end
          end
        end
      end
    end
  end
end
