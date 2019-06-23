class Evaluation < ApplicationRecord
  belongs_to :collaborador, required: false
  belongs_to :evaluator, required: false
  has_many :evaluation_abilities
end
