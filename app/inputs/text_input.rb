class TextInput < SimpleForm::Inputs::TextInput

  def input_html_classes
    super.push("form-control")
  end

end