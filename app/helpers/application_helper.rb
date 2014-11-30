module ApplicationHelper  
  
  def panel(title, id, options={}, &block)
    panel_class = options[:panel_class] ? "panel #{options[:panel_class]}" : "panel panel-default"
  
    heading = content_tag :div, class: "panel-heading" do
      content_tag :h3, class: "panel-title" do
        
        links = []
        options[:links].each do |l|
          links << link_to(l.first, l.second)
        end if options[:links]
        
        toggle_btn = content_tag :div, class: "pull-right" do
          content_tag :a, class: "panel-collapse", href: "#", data: { toggle: "collapse", target: "##{id}" } do
            content_tag :i, "", class: "fa fa-chevron-up"
          end
        end
        
        anchor_id = options[:anchor] || "#{id}_anchor"
        
        bookmark = content_tag :a, id: anchor_id, class: "anchor" do
          "#{title} #{' |' if options[:links]}"
        end
        
        bookmark.concat(links.join("|").concat(toggle_btn).html_safe).html_safe
      end
    end
    
    body = content_tag :div, class: "panel-body" do
      content_tag :div, id: "#{id}", class: "collapse in" do
        capture(&block).html_safe
      end
    end
    
    content_tag :div, class: panel_class do 
      heading << body
    end
  end
    
end