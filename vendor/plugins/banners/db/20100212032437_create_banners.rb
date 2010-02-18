class CreateBanners < ActiveRecord::Migration

  def self.up
    create_table :banners do |t|
      t.string :banner_name
      t.integer :position
      t.timestamps
    end

    add_index :banners, :id

    create_table :image_banners do |t|
      t.string :image_banner_file_name
      t.string :image_banner_content_type
      t.integer :image_banner_file_size
      t.datetime :image_banner_updated_at
      t.integer :banner_id
      t.integer :position
      t.timestamp      
    end

    page = Page.create(
      :title => "Banners",
      :link_url => "/banners",
      :deletable => false,
      :position => ((Page.maximum(:position, :conditions => "parent_id IS NULL") || -1)+1),
      :menu_match => "^/banners(\/|\/.+?|)$"
    )
    RefinerySetting.find_or_set(:default_page_parts, ["body", "side_body"]).each do |default_page_part|
      page.parts.create(:title => default_page_part, :body => nil)
    end

    add_index :image_banners, :id

    User.find(:all).each do |user|
      user.plugins.create(:title => "Banners", :position => (user.plugins.maximum(:position) || -1) +1)
    end

  end

  def self.down
    UserPlugin.destroy_all({:title => "Banners"})

    Page.find_all_by_link_url("/banners").each do |page|
      page.link_url, page.menu_match = nil
      page.deletable = true
      page.destroy
    end
    Page.destroy_all({:link_url => "/banners"})

    drop_table :banners
  end

end
