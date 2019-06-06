class ReportsTo < ApplicationRecord
  belongs_to :profile, required: false
end
