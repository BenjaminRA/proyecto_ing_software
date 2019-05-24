class Ability < ApplicationRecord
    has_many :profile_abilities
    has_many :profiles, through: :profile_abilities
    belongs_to :category
    belongs_to :professional_comp_areas
end
