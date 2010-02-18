class BannersController < ApplicationController

  before_filter :find_all_banners
  before_filter :find_page

  def show
    @banner = Banner.find(params[:id])

    # you can use meta fields from your model instead (e.g. browser_title)
    # by swapping @page for @banner in the line below:
    present(@page)
  end
  
  def index
    @banners = Banner.all

    present(@page)
  end
  
  def banner
    @banner = Banner.find(params[:id])

    # you can use meta fields from your model instead (e.g. browser_title)
    # by swapping @page for @banner in the line below:
    present(@page)
  end
  def gallery
    @banner = Banner.find(params[:id])

    # you can use meta fields from your model instead (e.g. browser_title)
    # by swapping @page for @banner in the line below:
    present(@page)
  end


protected

  def find_all_banners
    @banners = Banner.find(:all, :order => "position ASC")
  end

  def find_page
    @page = Page.find_by_link_url("/banners")
  end

end
