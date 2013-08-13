module FormHelper
  extend ActiveSupport::Concern
  
  # def search_form_for(record, *args, &block)
  #   if record.is_a?(Searchable::Base)
  #     options = args.extract_options!
  #     options.symbolize_keys!
  #   
  #     default_model_route = (polymorphic_path(record.model_class) rescue nil)
  #   
  #     options.reverse_merge!({ :url => default_model_route, :as => :search })
  #     raise "You have to manually specify :url in your form_for options..." unless options[:url].present?
  #   
  #     options[:html] ||= {}
  #     options[:html].reverse_merge!({ :method => :get })
  #     args << options
  #   end
  #   
  #   begin 
  #     simple_form_for(record, *args, &block)
  #   rescue
  #     form_for(record, *args, &block)
  #   end
  # end
end