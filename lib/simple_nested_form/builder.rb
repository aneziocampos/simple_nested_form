module SimpleNestedForm
  class Builder < ::SimpleForm::FormBuilder
    delegate :content_tag, :link_to, :after_nested_form, :capture, :to => :@template

    def link_to_add(*args, &block)
      if block_given?
        association = args.first
        options     = args.second || {}
      else
        name        = args.first
        association = args.second
        options     = args.third || {}
      end

      options.merge!(:"data-association" => association)

      after_nested_form(association) do
        model_object = object.class.reflect_on_association(association).klass.new

        content_tag :div, :id => "#{association}_fields_blueprint", :style => "display: none" do
          fields_for(association, model_object, :child_index => "new_#{association}", &nested_fields[association])
        end
      end

      if block_given?
        link_to(capture(&block), "javascript:void(0)", options)
      else
        link_to(name, "javascript:void(0)", options)
      end
    end

    def link_to_remove(*args, &block)
      if block_given?
        options = args.first || {}
      else
        name    = args.first
        options = args.second || {}
      end

      options.merge!(:"data-remove-association" => 1)

      hidden_field(:_destroy) + if block_given?
        link_to(capture(&block), "javascript:void(0)", options)
      else
        link_to(name, "javascript:void(0)", options)
      end
    end

    def fields_for(record_or_name_or_array, *args, &block)
      options = args.extract_options!
      options[:builder] = SimpleNestedForm::Builder

      super(record_or_name_or_array, *(args << options), &block)
    end

    def fields_for_with_nested_attributes(association, args, block)
      nested_fields[association] = block
      super
    end

    def fields_for_nested_model(name, association, args, block)
      content_tag :div, :class => "fields" do
        super
      end
    end

    private

    def nested_fields
      @nested_fields ||= {}
    end
  end
end
