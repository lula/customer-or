module ApplicationHelper  
  
  def panel(title, options, &block)
    heading = content_tag :div, class: "panel-heading" do
      content_tag :h3, class: "panel-title" do
        links = []
        options[:links].each do |l|
          links << link_to(l.first, l.second)
        end
        "#{title} | ".concat(links.join("|")).html_safe
      end
    end
    
    body = content_tag :div, class: "panel-body" do
      capture(&block).html_safe
    end
    
    content_tag :div, class: "panel panel-default" do 
      heading << body
    end
  end
    
end