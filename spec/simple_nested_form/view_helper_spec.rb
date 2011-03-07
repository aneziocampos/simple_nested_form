require "spec_helper"

describe SimpleNestedForm::ViewHelper do
  let(:template) { ActionView::Base.new }

  before do
    template.output_buffer = ""
    template.stub(:projects_path).and_return("")
    template.stub(:protect_against_forgery?).and_return(false)
  end

  it "creates a instance of SimpleNestedForm" do
    template.nested_form_for(Project.new) do |form|
      form.should be_instance_of SimpleNestedForm::Builder
    end
  end

  it "appends the nested fields after the end of the form" do
    template.after_nested_form(:tasks) { template.concat "Nested task" }
    template.nested_form_for(Project.new) {}
    template.output_buffer.should include("Nested task")
  end
end
