Refinery::Plugin.register do |plugin|
  plugin.title = "Banners"
  plugin.description = "Manage Banners"
  plugin.version = 1.0
  plugin.activity = {
    :class => Banner,
    :url_prefix => "edit",
    :title => 'banner_name'
  }
end