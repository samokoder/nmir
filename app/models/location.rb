class Location < ActiveRecord::Base
  has_many :sublocations, class_name: 'Location', foreign_key: "location_id"

  belongs_to :parent_location, class_name: 'Location', foreign_key: "location_id"

  before_save :transliterate_title

  # neighbors
  #has_many :neighborhoods, dependent: :destroy
  #has_many :neighbors, through: :neighborhoods
  has_and_belongs_to_many :neighbors, 
                          class_name: 'Location', 
                          join_table: 'neighborhoods',
                          foreign_key: 'location_id',
                          association_foreign_key: 'neighbor_id'

  # remember! add values to the end of array
  enum location_type: [:region, :district, :city, :admin_area, :non_admin_area, :street, :address, :landmark]


  # recursively collect all parent location nodes and return them in array
  def self.parent_locations(l, memo = [])
    if l.parent_location
      memo << l.parent_location
      Location.parent_locations(l.parent_location, memo)
    else
      return memo
    end
  end

  def parent?
    location_type == 'region'
  end

  private

  def transliterate_title
    self.translit = Russian::translit(self.title).downcase
  end
end
