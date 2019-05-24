class ReplaceBy < ApplicationRecord
  belongs_to :to_replace
  belongs_to :replacement
end
