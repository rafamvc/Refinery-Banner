class RefineryGenerator < Rails::Generator::NamedBase

  def initialize(*runtime_args)
    super(*runtime_args)
    $title_name = singular_name.gsub("_", " ").gsub(/\b([a-z])/) { $1.capitalize }
  end

  def banner
    "Usage: ./script/generate refinery singular_model_name attribute:type [attribute2:type ...]"
  end

  def manifest
    record do |m|
      # Copy controller, model and migration
      directories = ["vendor/plugins/#{plural_name}", "vendor/plugins/#{plural_name}/app", "vendor/plugins/#{plural_name}/app/controllers",
        "vendor/plugins/#{plural_name}/app/controllers/admin", "vendor/plugins/#{plural_name}/app/models", "vendor/plugins/#{plural_name}/app/views",
        "vendor/plugins/#{plural_name}/app/helpers", "vendor/plugins/#{plural_name}/app/views", "vendor/plugins/#{plural_name}/app/views/admin",
        "vendor/plugins/#{plural_name}/config", "vendor/plugins/#{plural_name}/rails"]

      directories.each do |dir|
        m.directory dir
      end

      m.template "controller.rb", "vendor/plugins/#{plural_name}/app/controllers/admin/#{plural_name}_controller.rb"
      m.template "model.rb", "vendor/plugins/#{plural_name}/app/models/#{singular_name}.rb"
      m.template "config/routes.rb", "vendor/plugins/#{plural_name}/config/routes.rb"

      # Create view directory
      admin_view_dir = File.join("vendor/plugins/#{plural_name}/app/views/admin", plural_name)
      m.directory admin_view_dir

      # Copy in all views
      admin_view_files = ['_form.html.erb', '_sortable_list.html.erb', 'edit.html.erb', 'index.html.erb', 'new.html.erb']

      admin_view_files.each do |view_file|
        m.template "views/admin/#{view_file}", "#{admin_view_dir}/#{view_file}"
      end

      m.template "views/admin/_singular_name.html.erb", "#{admin_view_dir}/_#{singular_name}.html.erb"

      # Now for the public views and controller
      public_dir = File.join("vendor/plugins/#{plural_name}/app/views/", plural_name)
      m.directory public_dir

      view_files = ['index.html.erb', 'show.html.erb']
      view_files.each do |view_file|
        m.template "views/#{view_file}", "#{public_dir}/#{view_file}"
      end

      m.template "public_controller.rb", "vendor/plugins/#{plural_name}/app/controllers/#{plural_name}_controller.rb"

      # Add in the init file that ties the plugin to the app.
      m.template "rails/init.rb", "vendor/plugins/#{plural_name}/rails/init.rb"

      m.directory 'db/migrate/'
      m.migration_template 'migration.rb', 'db/migrate', :assigns => {:migration_name => "Create#{class_name.pluralize}"}, :migration_file_name => "create_#{singular_name.pluralize}"

      puts "IMPORTANT"
      puts "---------------------------------------"
      puts "Now run 'rake db:migrate' to add the table to the DB"
      puts "---------------------------------------"
    end
  end

end
