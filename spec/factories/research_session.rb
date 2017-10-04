FactoryGirl.define do
  factory :research_session do
    trait :step_researcher do
      status :researcher

      researchers { build_list :researcher, 1 }
    end

    trait :step_topic do
      step_researcher
      status :topic
      topic 'A topic'
    end

    trait :step_purpose do
      step_topic
      status :purpose
      purpose 'A purpose'
    end

    trait :step_methodologies do
      step_purpose
      status :methodologies
      methodologies %w[interview survey]
    end

    trait :step_recording do
      step_methodologies
      status :recording
      recording_methods %w[audio video]
    end

    trait :step_data do
      step_recording
      status :data
      shared_with :team
      shared_duration '1 year'
      shared_use 'To train others'
    end

    trait :step_time_equipment do
      step_data
      status :time_equipment
      start_datetime DateTime.parse('1st Sep 2017')
      duration '1 week'
      participant_equipment 'A coat'
    end

    trait :step_expenses do
      step_time_equipment
      status :expenses
      travel_expenses_limit '10.00'
      food_expenses_limit '20.00'
      other_expenses_limit '1.00'
      receipts_required true
      food_provided 'Light canapés'
    end

    trait :step_incentive do
      step_expenses
      status :incentive
      incentive true
      payment_type :cash
      incentive_value '40.00'
    end

    trait :previewable do
      step_incentive # really just a readable alias
    end

    trait :nil_expenses do
      travel_expenses_limit nil
      food_expenses_limit   nil
      other_expenses_limit  nil
    end

    trait :zero_expenses do
      travel_expenses_limit 0.00
      food_expenses_limit   0.00
      other_expenses_limit  0.00
    end
  end
end
