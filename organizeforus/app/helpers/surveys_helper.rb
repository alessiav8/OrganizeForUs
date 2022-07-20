module SurveysHelper
    def link_to_add_fields(name, f, association)
        new_object = f.object.class.reflect_on_association(association).klass.new
        fields = f.fields_for(association, new_object,:child_index => "new_#{association}") do |builder|
          render(association.to_s.singularize + "_fields", :f => builder)
        end
        __link_to_function(name, "addField(this, \"#{association}\", \"#{escape_javascript(fields)}\")",
        :id=>"add-attach",
        :class=>"btn btn-default")
      end

      def link_to_remove_field(name, f)
        f.hidden_field(:_destroy) +
        __link_to_function(raw(name), "removeField(this)", :id =>"remove-attach", class: 'btn btn-default')
      end

      private

      def __link_to_function(name, on_click_event, opts={})
        link_to(name, 'javascript:;', opts.merge(onclick: on_click_event))
      end
    
end
