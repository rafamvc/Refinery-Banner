#!/usr/bin/env ruby
require 'fileutils'
REFINERY-BANNER_ROOT = File.expand_path(File.dirname(__FILE__) << "/..")
RAILS_ROOT = ARGV.first unless defined? RAILS_ROOT
unless RAILS_ROOT.nil? or RAILS_ROOT.length == 0
  dirs = [['db', 'migrate'], ['public', 'stylesheets'], ['public', 'javascripts']]
  dirs.each do |dir|
    FileUtils::makedirs File.join(RAILS_ROOT, dir)
  end
 
  copies = [
    {:from => ["db", "migrate"],:to => ["db", "migrate"],:filename => "20100212032437_create_banners.rb"},
    {:from => ["public", "stylesheets"],:to => ["public", "stylesheets"],:filename => "galleria.css"},
    {:from => ["public", "stylesheets"],:to => ["public", "stylesheets"],:filename => "mb.scrollable.css"},
    {:from => ["public", "javascripts"],:to => ["public", "javascripts"],:filename => "mbScrollable.js"}
    {:from => ["public", "javascripts"],:to => ["public", "javascripts"],:filename => "jquery.galleria.js"}
    {:from => ["public", "javascripts"],:to => ["public", "javascripts"],:filename => "mbGallery.js"}
    {:from => ["public", "images"],:to => ["public", "images"], :filename => "refinery-banner"}
  ]
copies.each do |copy|
    copy_from = File.join(REFINERY-BANNER_ROOT, copy[:from], copy[:filename])
copy_to = File.join(RAILS_ROOT, copy[:to], copy[:filename])
    unless File.exists?(copy_to)
FileUtils::copy_file copy_from, copy_to
    else
      puts "'#{File.join copy[:to], copy[:filename]}' already existed in your application so your existing file was not overwritten."
    end
  end
 
puts "---------"
puts "Copied all refinery-banner files."
puts "Now, run rake db:migrate and then rake paperclip:refresh"
else
  puts "Please specify the path of the project that you want to use the refinery-banner with, i.e. banner-install /path/to/project"
end