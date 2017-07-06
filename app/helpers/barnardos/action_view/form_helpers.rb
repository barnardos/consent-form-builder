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
    end
  end
end
