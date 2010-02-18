class Admin::BannersController < Admin::BaseController

  crudify :banner, :title_attribute => :banner_name

   def new
      @banner = Banner.new
      3.times {@banner.image_banners.build}
    end
end
