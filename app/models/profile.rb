class Profile < ApplicationRecord
    belongs_to :collaborators
    has_many :profile_abilities, :dependent => :destroy
    # has_many :sender,  through: :reports_tos, :foreign_key => 'sender_id', :dependent => :destroy
    # has_many :sender, through: :reports_tos, :dependent => :destroy
    # has_many :reciever, through: :reports_tos, :dependent => :destroy
    # has_many :replacement, through: :replace_bies, :dependent => :destroy
    # has_many :to_replace, through: :replace_bies, :dependent => :destroy
    # has_many :from, through: :direct_supervisions, :dependent => :destroy
    # has_many :to, through: :direct_supervisions, :dependent => :destroy
    has_many :abilities, through: :profile_abilities
    accepts_nested_attributes_for :profile_abilities, :reject_if => :all_blank, allow_destroy: true
end
