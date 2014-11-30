class DatetimePickerInput < SimpleForm::Inputs::StringInput 
  def input(wrapper_options)
    value = input_html_options[:value]
    value ||= object.send(attribute_name) if object.respond_to? attribute_name
    input_html_options[:value] ||= I18n.localize(value) if value.present?
    input_html_classes.push("datepicker form-control")
    super
  end
end