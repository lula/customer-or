module CsvExportable
  extend ActiveSupport::Concern
  
  module ClassMethods
    def to_csv
      CSV.generate do |csv|
        csv << self.fields.keys
        all.each do |obj|
          csv << obj.attributes.values_at(*fields.keys)
        end
      end
    end
  end
end