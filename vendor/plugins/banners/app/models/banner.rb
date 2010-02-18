class Banner < ActiveRecord::Base

  acts_as_indexed :fields => [:banner_name],
                  :index_file => [Rails.root.to_s, "tmp", "index"]

  validates_presence_of :banner_name
  validates_uniqueness_of :banner_name
  has_many :image_banners, :dependent => :destroy
  accepts_nested_attributes_for :image_banners , :reject_if => lambda { |a| a[:image_banner].blank? }, :allow_destroy => true
  
end
