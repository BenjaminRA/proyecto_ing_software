class Profile < ApplicationRecord
    has_many :profile_abilities
    has_many :reports_tos
    has_many :replace_bies
    has_many :abilities, through: :profile_abilities
    accepts_nested_attributes_for :profile_abilities
end
