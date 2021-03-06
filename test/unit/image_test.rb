require 'test_helper'

class ImageTest < ActiveSupport::TestCase

  fixtures :images

  def test_titles
    assert_equal "The%20world!.gif", images(:the_world).filename
    assert_equal "The World!", images(:the_world).title

    assert_equal "car-wallpapers19.jpg", images(:our_car).filename
    assert_equal "Car Wallpapers19", images(:our_car).title
  end

  def test_per_page
    assert_equal 18, Image.per_page(dialog = true)
    assert_equal 20, Image.per_page # dialog = false
  end

  def test_attachment_fu_options
    assert_equal 20.megabytes, Image.attachment_options[:max_size]
    
    # want to change this to ImageScience at some point. Rmagick sucks.
    assert_equal 'Rmagick', Image.attachment_options[:processor]
  end

end