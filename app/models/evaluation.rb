class Evaluation < ApplicationRecord
  belongs_to :collaborator, required: false
  belongs_to :evaluator, required: false
  belongs_to :profile, required: false
  has_many :evaluation_abilities
end
