class District < ActiveRecord::Base
  belongs_to :region
  has_many :cities
  
end
