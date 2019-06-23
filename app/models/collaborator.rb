class Collaborator < ApplicationRecord
  belongs_to :profile
  belongs_to :user
  belongs_to :state
  has_many :evaluations
  has_many :evaluators
end
