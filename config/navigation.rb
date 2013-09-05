# -*- coding: utf-8 -*-
# Configures your navigation
SimpleNavigation::Configuration.run do |navigation|
  # Specify a custom renderer if needed.
  # The default renderer is SimpleNavigation::Renderer::List which renders HTML lists.
  # The renderer can also be specified as option in the render_navigation call.
  # navigation.renderer = Your::Custom::Renderer

  # Specify the class that will be applied to active navigation items. Defaults to 'selected'
  navigation.selected_class = 'active'

  # Specify the class that will be applied to the current leaf of
  # active navigation items. Defaults to 'simple-navigation-active-leaf'
  # navigation.active_leaf_class = 'your_active_leaf_class'

  # Item keys are normally added to list items as id.
  # This setting turns that off
  # navigation.autogenerate_item_ids = false

  # You can override the default logic that is used to autogenerate the item ids.
  # To do this, define a Proc which takes the key of the current item as argument.
  # The example below would add a prefix to each key.
  # navigation.id_generator = Proc.new {|key| "my-prefix-#{key}"}

  # If you need to add custom html around item names, you can define a proc that will be called with the name you pass in to the navigation.
  # The example below shows how to wrap items spans.
  # navigation.name_generator = Proc.new {|name| "<span>#{name}</span>"}

  # The auto highlight feature is turned on by default.
  # This turns it off globally (for the whole plugin)
  # navigation.auto_highlight = false

  # Define the primary navigation
  navigation.items do |primary|
    # Add an item to the primary navigation. The following params apply:
    # key - a symbol which uniquely defines your navigation item in the scope of the primary_navigation
    # name - will be displayed in the rendered navigation. This can also be a call to your I18n-framework.
    # url - the address that the generated item links to. You can also use url_helpers (named routes, restful routes helper, url_for etc.)
    # options - can be used to specify attributes that will be included in the rendered navigation item (e.g. id, class etc.)
    #           some special options that can be set:
    #           :if - Specifies a proc to call to determine if the item should
    #                 be rendered (e.g. <tt>:if => Proc.new { current_user.admin? }</tt>). The
    #                 proc should evaluate to a true or false value and is evaluated in the context of the view.
    #           :unless - Specifies a proc to call to determine if the item should not
    #                     be rendered (e.g. <tt>:unless => Proc.new { current_user.admin? }</tt>). The
    #                     proc should evaluate to a true or false value and is evaluated in the context of the view.
    #           :method - Specifies the http-method for the generated link - default is :get.
    #           :highlights_on - if autohighlighting is turned off and/or you want to explicitly specify
    #                            when the item should be highlighted, you can set a regexp which is matched
    #                            against the current URI.  You may also use a proc, or the symbol <tt>:subpath</tt>. 
    #
    # primary.item :key_1, 'name', url, options

    # Add an item which has a sub navigation (same params, but with block)
    # primary.item :key_2, 'name', url, options do |sub_nav|
    #   # Add an item to the sub navigation (same params again)
    #   sub_nav.item :key_2_1, 'name', url, options
    # end

    # You can also specify a condition-proc that needs to be fullfilled to display an item.
    # Conditions are part of the options. They are evaluated in the context of the views,
    # thus you can use all the methods and vars you have available in the views.
    # primary.item :key_3, 'Admin', url, :class => 'special', :if => Proc.new { current_user.admin? }
    # primary.item :key_4, 'Account', url, :unless => Proc.new { logged_in? }

    # you can also specify a css id or class to attach to this particular level
    # works for all levels of the menu
    # primary.dom_id = 'menu-id'
    # primary.dom_class = 'menu-class'

    # You can turn off auto highlighting for a specific level
    # primary.auto_highlight = false


    primary.dom_class = "nav navbar-nav"
    
    primary.item :sep, "", class: "divider-vertical"
    
    if admin_signed_in?
      primary.item :users, t("views.navigation.user.title", default: "Users"), admin_users_url, highlights_on: /\/users/ do |sub_nav|
        sub_nav.dom_class = "list-group"
        sub_nav.item :head_user, t("views.navigation.user.title", default: "Users"),"#", class: "list-group-header"
        sub_nav.item :users, t("views.navigation.customer.search", default: "Search"), admin_users_url, class: "list-group-item"
        sub_nav.item :new_user, t("views.navigation.customer.new", default: "New"), new_admin_user_url, class: "list-group-item"
      end
      primary.item :sep, "", class: "divider-vertical"
      primary.item :organizations, t("views.navigation.organization.title", default: "Organizations"), admin_organizations_url, highlights_on: /\/organizations/ do |sub_nav|
        sub_nav.dom_class = "list-group"
        sub_nav.item :head_org, t("views.navigation.organization.title", default: "Organizations"), "#", class: "list-group-header"
        sub_nav.item :organizations, t("views.navigation.organization.search", default: "Search"), admin_organizations_url, class: "list-group-item"
        sub_nav.item :new_organization, t("views.navigation.organization.new", default: "New"), new_admin_organization_url, class: "list-group-item"
      end
      
      primary.item :sep, "", class: "divider-vertical"
    end
    
    if user_signed_in? || admin_signed_in?
      primary.item :customers, t("views.navigation.customer.title", default: "Customers"), customers_url, highlights_on: /\/customers|\/representatives/ do |sub_nav|
        sub_nav.dom_class = "list-group"
        sub_nav.item :head_cust, t("views.navigation.customer.title", default: "Customers"),"#", class: "list-group-header"
        sub_nav.item :customers, t("views.navigation.customer.search", default: "Search"), customers_url, class: "list-group-item"
        sub_nav.item :new_customer, t("views.navigation.customer.new", default: "New"), new_customer_url, class: "list-group-item"
        sub_nav.item :head_rep, t("views.navigation.representative.title", default: "Representatives"), "#", class: "list-group-header"
        sub_nav.item :representative, t("views.navigation.representative.search", default: "Search"), representatives_url, class: "list-group-item"
        sub_nav.item :new_representative, t("views.navigation.representative.new", default: "New"), new_representative_url, class: "list-group-item"
      end
      primary.item :sep, "", class: "divider-vertical"
      primary.item :visits, t("views.navigation.visit.title", default: "Visits"), visits_url, highlights_on: /\/visits|\/visit_plans/ do |sub_nav|
        sub_nav.dom_class = "list-group"
        sub_nav.item :head_vis, t("views.navigation.visit.title", default: "Visits"), "#", class: "list-group-header"
        sub_nav.item :visits, t("views.navigation.visit.search", default: "Search"), visits_url, class: "list-group-item"
        sub_nav.item :new_visit, t("views.navigation.visit.new", default: "New"), new_visit_url, class: "list-group-item"
        sub_nav.item :head_vispl,  t("views.navigation.visit_plan.title", default: "Visit Plan"), "#", class: "list-group-header"
        sub_nav.item :new_visit_plan, "New", new_visit_plan_path, class: "list-group-item"
      end
    end
  end
end
