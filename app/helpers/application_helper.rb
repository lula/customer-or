module ApplicationHelper  
  
  def panel(title, id, options={}, &block)
    heading = content_tag :div, class: "panel-heading" do
      content_tag :h3, class: "panel-title" do
        
        links = []
        options[:links].each do |l|
          links << link_to(l.first, l.second)
        end if options[:links]
        
        toggle_btn = content_tag :div, class: "pull-right" do
          content_tag :a, class: "panel-collapse", href: "#", data: { toggle: "collapse", target: "##{id}" } do
            content_tag :i, "", class: "icon-chevron-sign-up"
          end
        end
        
        "#{title} #{'| ' if options[:links]}".concat(links.join("|").concat(toggle_btn)).html_safe
      end
    end
    
    body = content_tag :div, class: "panel-body" do
      content_tag :div, id: "#{id}", class: "collapse in" do
        capture(&block).html_safe
      end
    end
    
    content_tag :div, class: "panel panel-default" do 
      heading << body
    end
  end
    
end