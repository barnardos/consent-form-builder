require 'singleton'

class ResearchSession
  class Steps
    include Singleton

    PARAMS = ActiveSupport::OrderedHash[{
      researcher:    [researchers_attributes:
        [:researcher_name, :researcher_phone, :researcher_email]],
      topic:         [:topic],
      purpose:       [:purpose],
      methodologies: [:other_methodology, methodologies: []],
      recording:     [:other_recording_method, recording_methods: []],
      data:          [:shared_with, :shared_duration, :shared_use],
      time_equipment: [:start_datetime, :duration, :participant_equipment],
      expenses:      [:travel_expenses_limit, :food_expenses_limit, :other_expenses_limit,
                      :receipts_required, :food_provided],
      incentive:     [:incentive, :payment_type, :incentive_value]
    }]

    def reached_step?(session, step)
      step = step.to_sym
      return false if session.status == 'new'
      step_indices.fetch(session.status.to_sym) >= step_indices.fetch(step)
    end

    def step_keys
      @step_keys ||= PARAMS.keys
    end

    ##
    # Returns a hash of attribute names to step names in the wizard
    def attr_to_step(attr)
      @attrs_to_steps ||=
        PARAMS.each_with_object({}) do |kv, params_to_steps|
          step, params = *kv
          params.each do |param|
            case param
            when Symbol
              params_to_steps[param] = step
            when Hash
              param.keys.each do |array_param|
                nested_params = param[array_param]
                if nested_params.any?
                  # Only checks one level of nesting. If you find yourself passing
                  # a doubly-nested thing hash or deeper here this will need
                  # revisiting
                  nested_params.each { |nested_param| params_to_steps[nested_param] = step }
                else
                  params_to_steps[array_param] = step
                end
              end
            end
          end
        end
      @attrs_to_steps.fetch(attr)
    end

  private

    ##
    # A hash of step names as symbols to numeric indices, with age: 0, name: 1 etc
    def step_indices
      @step_indices ||= step_keys.each_with_index.map { |step, index| [step, index] }.to_h
    end
  end
end
