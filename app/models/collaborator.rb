class Collaborator < ApplicationRecord
  belongs_to :profile, optional: true
  belongs_to :user
  belongs_to :state
  has_many :evaluations
  has_many :evaluators
end
