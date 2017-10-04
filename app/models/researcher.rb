class Researcher < ApplicationRecord
  belongs_to :research_session

  validates :researcher_name, presence: true
  validates :researcher_email, format: /@/
end
