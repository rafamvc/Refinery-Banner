require 'paperclip'
class ImageBanner < ActiveRecord::Base

  acts_as_indexed :fields => [:image_banner_file_name, :image_banner_content_type],
                  :index_file => [Rails.root.to_s, "tmp", "index"]
  belongs_to :banner
  has_attached_file :image_banner, :styles => { :medium => "550x550>", :large => "900x900>", :thumb => "100x100>" }
end
