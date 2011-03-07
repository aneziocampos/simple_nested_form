module SimpleNestedForm
  module ViewHelper
    def nested_form_for(*args, &block)
      options = args.extract_options!.reverse_merge(:builder => SimpleNestedForm::Builder)

      simple_form_for(*(args << options), &block).tap do |output|
        form_callbacks.each do |callback|
          output << callback.call
        end
      end
    end

    def after_nested_form(association, &block)
      unless form_associations.include? association
        form_associations << association 
        form_callbacks << block
      end
    end

    private

    def form_associations
      @form_associations ||= []
    end

    def form_callbacks
      @form_callbacks ||= []
    end
  end
end

class ActionView::Base
  include SimpleNestedForm::ViewHelper
end
