class Role < ApplicationRecord
    has_many :users
    validates :title, presence:true
    
end
