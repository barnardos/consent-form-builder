FactoryGirl.define do
  factory :research_session do
    factory :researcher do
      researcher_name 'Rachel Researcher'
      researcher_email 'r.researcher@barnardos.org.uk'
    end

    factory :topic, parent: :researcher do
      topic 'A topic'
    end

    factory :purpose, parent: :topic do
      purpose 'A purpose'
    end

    factory :methodologies, parent: :purpose do
      methodologies %w[interview survey]
    end

    factory :recording, parent: :methodologies do
      recording_methods %w[audio video]
    end

    factory :data, parent: :recording do
      shared_with :team
      shared_duration '1 year'
      shared_use 'To train others'
    end

    factory :time_equipment, parent: :data do
      start_datetime DateTime.parse('1st Sep 2017')
      duration '1 week'
      participant_equipment 'A coat'
    end

    factory :expenses, parent: :time_equipment do
      travel_expenses_limit '10.00'
      food_expenses_limit '20.00'
      other_expenses_limit '1.00'
      receipts_required true
      food_provided 'Light canapés'
    end

    factory :incentive, parent: :expenses do
      incentive true
      payment_type :cash
      incentive_value '40.00'
    end
  end
end
