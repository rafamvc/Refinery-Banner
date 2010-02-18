require 'fileutils'
require 'pathname'
require 'yaml'
require 'bundler/rubygems-ext'

module Bundler
  VERSION = "0.9.6"

  autoload :Definition,          'bundler/definition'
  autoload :Dependency,          'bundler/dependency'
  autoload :Dsl,                 'bundler/dsl'
  autoload :Environment,         'bundler/environment'
  autoload :Index,               'bundler/index'
  autoload :Installer,           'bundler/installer'
  autoload :RemoteSpecification, 'bundler/remote_specification'
  autoload :Resolver,            'bundler/resolver'
  autoload :Runtime,             'bundler/runtime'
  autoload :Settings,            'bundler/settings'
  autoload :SharedHelpers,       'bundler/shared_helpers'
  autoload :Source,              'bundler/source'
  autoload :Specification,       'bundler/specification'
  autoload :UI,                  'bundler/ui'

  class BundlerError < StandardError
    def self.status_code(code = nil)
      return @code unless code
      @code = code
    end

    def status_code
      self.class.status_code
    end
  end

  class GemfileNotFound  < BundlerError; status_code(10) ; end
  class GemNotFound      < BundlerError; status_code(7)  ; end
  class VersionConflict  < BundlerError; status_code(6)  ; end
  class GemfileError     < BundlerError; status_code(4)  ; end
  class GitError         < BundlerError; status_code(11) ; end
  class DeprecatedMethod < BundlerError; status_code(12) ; end
  class DeprecatedOption < BundlerError; status_code(12) ; end

  class << self
    attr_writer :ui, :bundle_path

    def configure
      @configured ||= begin
        configure_gem_home_and_path
        true
      end
    end

    def ui
      @ui ||= UI.new
    end

    def bundle_path
      @bundle_path ||= begin
        path = settings[:path] || "#{Gem.user_home}/.bundle/#{Gem.ruby_engine}/#{Gem::ConfigMap[:ruby_version]}"
        Pathname.new(path).expand_path(root)
      end
    end

    def setup(*groups)
      gemfile = default_gemfile
      load(gemfile).setup(*groups)
    end

    def require(*groups)
      gemfile = default_gemfile
      load(gemfile).require(*groups)
    end

    def load(gemfile = default_gemfile)
      root = Pathname.new(gemfile).dirname
      Runtime.new root, definition(gemfile)
    end

    def definition(gemfile = default_gemfile)
      configure
      root = Pathname.new(gemfile).dirname
      lockfile = root.join("Gemfile.lock")
      if lockfile.exist?
        Definition.from_lock(lockfile)
      else
        Definition.from_gemfile(gemfile)
      end
    end

    def home
      Pathname.new(bundle_path).join("bundler")
    end

    def install_path
      home.join("gems")
    end

    def cache
      bundle_path.join('cache/bundler')
    end

    def root
      default_gemfile.dirname
    end

    def settings
      @settings ||= Settings.new(root)
    end

  private

    def default_gemfile
      SharedHelpers.default_gemfile
    end

    def configure_gem_home_and_path
      if settings[:disable_shared_gems]
        ENV['GEM_HOME'] = File.expand_path(bundle_path, root)
        ENV['GEM_PATH'] = ''
      else
        gem_home, gem_path = Gem.dir, Gem.path
        ENV["GEM_PATH"] = [gem_home, gem_path].flatten.compact.join(File::PATH_SEPARATOR)
        ENV["GEM_HOME"] = bundle_path.to_s
      end

      Gem.clear_paths
    end
  end
end
