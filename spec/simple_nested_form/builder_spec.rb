require 'spec_helper'

describe SimpleNestedForm::Builder do
  let(:project)  { Project.new }
  let(:template) { ActionView::Base.new }
  let(:builder)  { SimpleNestedForm::Builder.new(:item, project, template, {}, proc {}) }

  before { template.output_buffer = "" }

  describe "fields wrapper" do
    before  { project.tasks.build }
    subject { builder.fields_for(:tasks) { "Task"} }

    it "surrounds the nested fields with a div with class fields" do
      subject.should == '<div class="fields">Task</div>'
    end
  end

  describe "link to add" do
    subject { Nokogiri::HTML(builder.link_to_add("Add me plz", :tasks)).css("a").first }

    its(:text) { should == "Add me plz" }

    it "contains a class named add_nested_fields" do
      subject.attr("class").should include "add_nested_fields"
    end

    it "contains an attribute named data-association" do
      subject.attr("data-association").should == "tasks"
    end
  end

  describe "link to remove" do
    let(:output) { Nokogiri::HTML(builder.link_to_remove("Remove me plz")) }

    describe "the link itself" do
      subject { output.css("a").first }

      its(:text) { should == "Remove me plz" }

      it "contains a class named remove_nested_fields" do
        subject.attr("class").should include "remove_nested_fields"
      end
    end

    it "generate a destroy hidden field" do
      output.css("input[type='hidden'][name*='_destroy']").should have(1).element
    end
  end
end
