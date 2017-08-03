require 'singleton'

class ResearchSession
  class Steps
    include Singleton

    PARAMS = ActiveSupport::OrderedHash[{
      age:           [:age],
      methodologies: [methodologies: []],
      recording:     [recording_methods: []],
      focus:         [:focus],
      researcher:    [:researcher_name, :researcher_phone,
                      :researcher_email, :researcher_other_name],
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
          case params.first
          when Symbol
            params.each { |param| params_to_steps[param] = step }
          when Hash
            params.first.keys.each { |param| params_to_steps[param] = step }
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