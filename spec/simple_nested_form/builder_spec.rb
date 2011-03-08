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

  shared_examples_for "a link_to_add" do |link_name|
    let(:link) { builder.link_to_add(link_name, :tasks, :class => "add") }

    subject { Nokogiri::HTML(link).css("a").first }

    its(:text) { should == link_name }

    it "contains an attribute named data-association" do
      subject.attr("data-association").should == "tasks"
    end

    describe "options" do
      it "contains a class named add" do
        subject.attr("class").should include "add"
      end
    end
  end

  shared_examples_for "a link_to_remove" do |link_name|
    let(:link) { builder.link_to_remove(link_name, :class => "remove") }

    subject { Nokogiri::HTML(link).css("a").first }

    its(:text) { should == link_name }

    it "contains an attribute named data-remove-association" do
      subject.attr("data-remove-association").should be_present
    end

    it "generate a destroy hidden field" do
      Nokogiri::HTML(link).css("input[type='hidden'][name*='_destroy']").should have(1).element
    end

    describe "options" do
      it "contains a class named add" do
        subject.attr("class").should include "remove"
      end
    end
  end

  describe "link to add" do
    context "without a block" do
      it_should_behave_like "a link_to_add", "Add me plz" do
        let(:link) { builder.link_to_add("Add me plz", :tasks, :class => "add") }
      end
    end
    
    context "with a block" do
      it_should_behave_like "a link_to_add", "A label in a block baby!" do
        let(:link) do
          builder.link_to_add(:tasks, :class => "add") { "A label in a block baby!" }
        end
      end
    end
  end

  describe "link to remove" do
    context "without a block" do
      it_should_behave_like "a link_to_remove", "Remove me plz" do
        let(:link) { builder.link_to_remove("Remove me plz", :class => "remove") }
      end
    end
    
    context "with a block" do
      it_should_behave_like "a link_to_remove", "Remove me plz" do
        let(:link) do
          builder.link_to_remove(:class => "remove") { "Remove me plz" }
        end
      end
    end
  end
end
