# frozen_string_literal: true

class ComponentGenerator < Rails::Generators::Base
  argument :component_name, required: true, desc: 'Component name, e.g: Breadcrumbs'

  def create_view_file
    create_file "#{component_path}/_index.html.erb"
  end

  def create_css_file
    create_file "#{component_path}/index.css" do
      "/** @define #{component_name}; */\n"
    end
  end

  def create_js_file
    create_file "#{component_path}/index.js" do
      # require component's CSS inside JS automatically
      "import \"./index.css\";\n"
    end
  end

  protected

  def component_path
    "frontend/components/#{component_name}"
  end
end
