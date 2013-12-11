require "opal/starter/kit/version"
require 'yaml'
require 'thor'
module Opal
  module Starter
    module Kit
      # utilities to setup rvm files
      class RvmUtil

        # takes rvm info ruby's version and make it something you set in .ruby-version
        def rvm_versionize(version)
          version.sub("p", "-p")
        end

        def get_rvm_version(project_name)
          ruby_version = rvm_versionize(YAML.load(`rvm info ruby`).values.first["ruby"]["version"])
        end

      end

      class Command < Thor
        include Thor::Actions

        source_root( File.dirname(__FILE__) + "/../../..")
        argument :type
        argument :project_name
        desc "new OPAL_APP_TYPE PROJECT_NAME", "creates a new Opal app "
        # def new(type, project_name)
        def new
          puts type, project_name

          create_project_files project_name
          create_initial_source project_name
          create_specs project_name
          create_ruby_version_gemset_files project_name
        end

        private

        def create_project_files project_name
          empty_directory project_name
          create_gemfile project_name
          create_rakefile project_name
          create_example_html project_name
          empty_directory "#{project_name}/js"

        end

        def create_example_html(project_name)
          template "templates/static/index.html.tt", "#{project_name}/index.html"
        end

        def create_ruby_version_gemset_files project_name
          ruby_version = RvmUtil.new.get_rvm_version(project_name)
          if ruby_version
            create_file "#{project_name}/.ruby-version", ruby_version
            create_file "#{project_name}/.ruby-gemset", project_name
          end
        end

        def create_specs project_name
          empty_directory "#{project_name}/spec"
          template "templates/static/application_spec.rb.tt", "#{project_name}/spec/application_spec.rb"
          template "templates/static/spec_index.html.tt", "#{project_name}/spec/index.html"
        end

        def create_gemfile(project_name)
          create_file "#{project_name}/Gemfile" do
            lines = ["source 'http://rubygems.org'", ""]
            add_gems(lines, "opal", "opal-rspec", "opal-jquery", "opal-sprockets", )
            lines.join "\n"
          end
        end

        def create_initial_source project_name
          empty_directory "#{project_name}/app"
          template "templates/static/application.rb.tt", "#{project_name}/app/application.rb"
        end

        def create_rakefile(project_name)
          template "templates/static/Rakefile.tt", "#{project_name}/Rakefile"
        end

        def add_gems(lines_array, * gems)
          gems.each { |gem| lines_array << "gem '#{gem}'"}
        end

      end

    end
  end
end
