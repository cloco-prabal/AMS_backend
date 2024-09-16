class User < ApplicationRecord
    belongs_to :role
    has_secure_password
    enum gender: { m: 0, f: 1, o: 2 }
  
    validates :first_name, presence: true
    validates :last_name, presence: true
    validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: true
    validates :password, presence: true, length: { minimum: 6 }
    validates :phone, presence: true, format: { with: /\A[0-9+\-() ]+\z/, message: "only allows valid phone numbers" }
    validates :dob, presence: true
    validates :gender, presence: true, inclusion: { in: genders.keys }
    validates :address, presence: true
  end
  