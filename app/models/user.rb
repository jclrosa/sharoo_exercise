class User < ApplicationRecord
  has_many :bookings

  #Guarantee user email format
  validates :email, format: /@/

  #Only allow passwords between 8 and 20 character
  validates :password, length: 8..20
end
