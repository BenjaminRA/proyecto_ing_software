class Evaluator < ApplicationRecord
  belongs_to :collaborator, required: false
  belongs_to :period, required: false
  has_many :evaluations
end
