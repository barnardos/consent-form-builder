module Barnardos
  module ActionView
    module FormHelpers
      ##
      # <!-- Example HTML output for labelled_text_field_tag :participant_name -->
      # <div class="textfield " id="participant_name-wrapper">
      #   <label class="textfield__label textfield__label--bold" for="participant_name">
      #     What is the name of the research participant?
      #     <span class="textfield__hint">Full name</span>
      #   </label>
      #   <input id="participant_name" class="textfield__input" name="participant_name" type="text">
      # </div>
      def labelled_text_field_tag(name, label, value: nil ,
                                  text_options: {}, label_options: {})
        content_tag :div, class: 'textfield', id: "#{name}-wrapper" do
          concat(
            label_tag(name, class: 'textfield__label textfield__label--bold') do
              concat(label)
              concat(content_tag(:span, label_options[:hint], class: 'textfield__hint')) if label_options[:hint]
            end
          )
          concat(text_field_tag(name, value, text_options.reverse_merge(class: 'textfield__input')))
        end
      end

      ##
      # <!-- Example HTML output for:
      #    vertical_radio_list :age, [['under12', 'Under 12 years old']]
      #    or
      #    vertical_radio_list :age, {'under12' => 'Under 12 years old'} -->
      #
      # <fieldset class="vertical-radio-list">
      # <legend class="vertical-radio-list__legend"></legend>
      #
      # <div class="vertical-radio-list__choice">
      #     <input class="vertical-radio-list__checkbox" id="age-under12" type="radio" name="age" value="under12">
      #     <label class="vertical-radio-list__label" for="age-under12">Under 12 years old</label>
      # </div>
      # </fieldset>
      def vertical_radio_list(name, selection_list, options = {})
        content_tag :fieldset, class: 'vertical-radio-list' do
          selection_list.each do |value, text|
            id = "#{name}-#{value}"
            concat(
              content_tag(:div, class: 'vertical-radio-list__choice') do
                concat(radio_button_tag(name, value, false, class: 'vertical-radio-list__checkbox', id: id))
                concat(label_tag(name, text, class: 'vertical-radio-list__label', for: id))
              end
            )
          end
        end
      end

    end
  end
end
