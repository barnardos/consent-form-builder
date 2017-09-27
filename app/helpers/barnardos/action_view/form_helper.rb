module Barnardos
  module ActionView
    module FormHelper
      def barnardos_form_with(**options, &block)
        disable_field_error_proc do
          form_with(**options.merge(builder: Barnardos::ActionView::FormBuilder), &block)
        end
      end

      TAG_PASSTHROUGH_PROC = proc do |html_tag, _instance|
        html_tag.html_safe
      end

      def disable_field_error_proc
        original_field_error_proc = ::ActionView::Base.field_error_proc
        ::ActionView::Base.field_error_proc = TAG_PASSTHROUGH_PROC
        yield
      ensure
        ::ActionView::Base.field_error_proc = original_field_error_proc
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
        wrapper_tag(
          object_name, method, class: 'textfield js-highlight-control'
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

      ##
      # <!-- Example HTML output for labelled_textarea_field_tag :participant_description -->
      # <div class="textarea js-textarea" id="participant_description-wrapper">
      #   <label class="textarea__label" for="participant_description">
      #     Describe the research participant
      #     <span class="textarea__hint">Height, experience, mood</span>
      #   </label>
      #   <textarea id="participant_description"
      #             class="textarea__input" name="participant_description"></textarea>
      # </div>
      def labelled_text_area(object_name, method, label: nil,
                             label_options: {}, text_options: {})
        text_options[:class] =
          "#{(text_options[:class] || '')} textarea__input js-highlight-control__input"
        label_options[:class] = (label_options[:class] || '') + ' textarea__label'

        wrapper_tag(object_name, method, class: 'textarea js-highlight-control') do
          concat(
            label(object_name, method, label_options) do
              if label.present?
                concat(label)
              else
                concat(
                  ::ActionView::Helpers::Tags::Translator.new(
                    nil, object_name.to_s, method.to_s, scope: 'helpers.label'
                  ).translate
                )
              end
              if label_options[:hint]
                concat(content_tag(:span, label_options[:hint], class: 'textarea__hint'))
              end
            end
          )

          concat(text_area(object_name, method, text_options.reverse_merge(rows: 4)))
        end
      end

      def radio_group_vertical(
        object, method, collection, options = {}, legend: nil, legend_options: {}
      )
        wrapper_tag object, method, tag: :fieldset, class: 'radio-group radio-group__vertical' do
          next unless collection.any?

          # Render a legend for the fieldset, with an optional hint and optional class
          concat(
            content_tag(:span) do
              content_tag(:legend, class: "radio-group__legend #{legend_options[:class]}") do
                concat(legend)
                if legend_options[:hint]
                  concat(content_tag(:span, legend_options[:hint], class: 'radio-group__hint'))
                end
              end
            end
          )

          collection = Array(collection)
          buttons = collection_radio_buttons(
            object, method, collection, :first, :last, options
          ) do |b|
            content_tag :div, class: 'radio-group__choice' do
              b.radio_button(class: 'radio-group__input') +
                b.label(class: 'radio-group__label')
            end
          end

          concat(buttons)
        end
      end

      def checkbox_group_vertical(
        object_name, method, collection, options = {}, legend: nil, legend_options: {}
      )
        wrapper_tag(
          object_name, method,
          tag: :fieldset, class: 'checkbox-group checkbox-group__vertical'
        ) do
          next unless collection.any?

          concat(
            content_tag(:span) do
              content_tag(:legend, class: "checkbox-group__legend #{legend_options[:class]}") do
                concat(legend)
                if legend_options[:hint]
                  concat(content_tag(:span, legend_options[:hint], class: 'checkbox-group__hint'))
                end
              end
            end
          )

          # Make sure we're not using Symbols for key comparison, as collection_check_boxes
          # will use a straight `include?` to check for checked values. to_s it here
          # This map will deal with both Hash and Array
          collection = collection.map { |k, v| [k.to_s, v] }
          concat(
            collection_check_boxes(
              object_name, method, collection, :first, :last, options
            ) do |b|
              content_tag :div, class: 'checkbox-group__choice' do
                b.check_box(class: 'checkbox-group__input') +
                  b.label(class: 'checkbox-group__label')
              end
            end
          )
        end
      end

    private

      def wrapper_tag(object_name, method, options = {})
        options.reverse_merge!(tag: :div)
        content_tag(
          options[:tag],
          id: "#{method}-wrapper",
          class: "#{options[:class]} #{'has-error' if errors_on?(object_name, method)}"
        ) do
          yield
        end
      end

      def errors_on?(object_name, method)
        assigns[object_name]&.errors&.[](method)&.any?
      end
    end
  end
end
