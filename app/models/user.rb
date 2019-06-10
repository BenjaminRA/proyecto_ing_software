class User < ApplicationRecord
    has_one :collaborator
    has_one :admin
    has_secure_password
end
