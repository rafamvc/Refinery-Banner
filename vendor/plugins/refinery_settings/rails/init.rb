Refinery::Plugin.register do |plugin|
  plugin.title = "Settings"
  plugin.description = "Manage Refinery settings"
  plugin.version = 1.0
  plugin.menu_match = /admin\/(refinery_)?settings$/
  plugin.activity = {
    :class => RefinerySetting,
    :title => 'title',
    :url_prefix => 'edit',
    :created_image => "cog_add.png",
    :updated_image => "cog_edit.png"
  }
end
