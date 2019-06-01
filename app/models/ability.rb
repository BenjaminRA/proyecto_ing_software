class Ability < ApplicationRecord
  belongs_to :abilities_type
  belongs_to :area, optional: true
end
