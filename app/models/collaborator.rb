class Collaborator < ApplicationRecord
  belongs_to :profile
  belongs_to :user
  belongs_to :state
end
