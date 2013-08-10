module Searchable
  extend ActiveSupport::Concern
  
  class Base
    extend ActiveModel::Naming

    attr_reader :attributes, :model_class, :attributes_merged
  
    def initialize(klass, options)
      @model_class       = klass
      @attributes        = options
      @attributes_merged = @attributes.reverse_merge(klass.scopes.keys.inject({}) { |m,o| m[o] = nil; m; })

      @attributes_merged.each do |attribute, value|
        class_eval <<-RUBY
          attr_accessor :#{attribute}_multi_params
      
          def #{attribute}
            @attributes[:#{attribute}]
          end
        
          def #{attribute}=(val)
            @attributes[:#{attribute}] = val
          end
        RUBY
      end
    end
  
    def build_relation
      return model_class if attributes.empty?
      attributes.reject { |k,v| v.blank? || v.to_s == "false" }.inject(model_class) do |s, k|
        if model_class.scopes.keys.include?(k.first.to_sym)
          if k.second.is_a?(Array) && multi_params?(k.first)
            s.send(*k.flatten)
          elsif k.second.to_s == "true"
            s.send(k.first)
          else
            s.send(k.first, k.second)
          end

        else
          s
        end
      end
    end

    def to_key; nil; end
  
    def method_missing(method_name, *args)
      build_relation.send(method_name, *args)
    end
  
    protected
    def multi_params?(attribute)
      send("#{attribute}_multi_params").present?
    end
  end
  
  module ClassMethods
    def search(options={})
      Searchable::Base.new(self, options.present? ? options : {})
    end
  end
end
