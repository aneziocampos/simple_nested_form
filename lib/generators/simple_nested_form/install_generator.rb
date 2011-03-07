module SimpleNestedForm
  module Generators
    class InstallGenerator < Rails::Generators::Base
      desc "Copy NestedSimpleForm installation files"
      source_root File.expand_path("../templates", __FILE__)

      def copy_javascripts
        copy_file "simple_nested_form.js", "public/javascripts/simple_nested_form.js"
      end
    end
  end
end
