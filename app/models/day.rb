class Day < ApplicationRecord
  belongs_to :program
  has_many :reflection_answers, dependent: :destroy
end
