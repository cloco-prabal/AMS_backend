class Artist < ApplicationRecord

    has_many :musics, dependent:  :destroy

    enum gender: {m:0, f:1, o:2} 

    validates :name, presence:true
    validates :dob, presence:true
    validates :gender, presence:true, inclusion: {in: genders.keys}
    validates :address, presence:true
    validates :first_release_year, presence:true
    
end
