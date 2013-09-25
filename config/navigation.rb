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

    primary.dom_class = "list-group"
        
    if user_signed_in?
      primary.item :users_menu, t("views.navigation.user.title", default: "Users"), admin_users_url, class: "list-group-header", if: ->{can?(:read, User)}, highlights_on: /\/users/ do |sub_nav|
        if current_user.admin?
          sub_nav.item :src_users, t("views.navigation.user.search", default: "Search"), admin_users_url, class: "list-group-item"
          sub_nav.item :new_user, t("views.navigation.user.new", default: "New"), new_admin_user_url, class: "list-group-item", if: ->{can?(:create, User)}
        else 
          sub_nav.item :show_user, current_user.name || current_user.email, edit_admin_user_url(current_user), class: "list-group-item", if: ->{can?(:edit, User)}
        end
      end
      primary.item :organizations, t("views.navigation.organization.title", default: "Organizations"), organizations_url, class: "list-group-header", if: ->{can?(:read, Organization)}, highlights_on: /\/organizations/ do |sub_nav|
        sub_nav.item :src_organizations, t("views.navigation.organization.search", default: "Search"), organizations_url, class: "list-group-item"
        sub_nav.item :new_organization, t("views.navigation.organization.new", default: "New"), new_organization_url, class: "list-group-item", if: ->{can?(:create, Organization)}
      end
    
      primary.item :customers, t("views.navigation.customer.title", default: "Customers"), customers_url, class: "list-group-header", if: ->{can?(:read, Customer)}, highlights_on: /\/customers/ do |sub_nav|
        sub_nav.item :src_customers, t("views.navigation.customer.search", default: "Search"), customers_url, class: "list-group-item"
        sub_nav.item :new_customer, t("views.navigation.customer.new", default: "New"), new_customer_url, class: "list-group-item", if: ->{can?(:create, Customer)}
        if current_user.admin?
          sub_nav.item :import_customers, t("views.navigation.customer.import", default: "Import"), import_customers_url, class: "list-group-item", if: ->{can?(:create, User)}
        end
      end
            
      primary.item :representative_menu, t("views.navigation.representative.title", default: "Representatives"), representatives_url, class: "list-group-header", if: ->{can?(:read, Representative)}, highlights_on: /\/representatives/ do |sub_nav|
        sub_nav.item :src_rep, t("views.navigation.representative.search", default: "Search"), representatives_url, class: "list-group-item"
        sub_nav.item :new_rep, t("views.navigation.representative.new", default: "New"), new_representative_url, class: "list-group-item", if: ->{can?(:create, Representative)}
      end        
      
      primary.item :visits, t("views.navigation.visit.title", default: "Visits"), visits_url, class: "list-group-header",  if: ->{can?(:read, Visit)}, highlights_on: /\/visits/ do |sub_nav|
        sub_nav.item :srcvisits, t("views.navigation.visit.search", default: "Search"), visits_url, class: "list-group-item"
        sub_nav.item :new_visit, t("views.navigation.visit.new", default: "New"), new_visit_url, class: "list-group-item", if: ->{can?(:create, Visit)}
      end
      
      primary.item :visit_plans,  t("views.navigation.visit_plan.title", default: "Visit Plan"), visit_plans_url, class: "list-group-header", if: ->{can?(:read, Visit)}, highlights_on: /\/visit_plans/ do |sub_nav|
        sub_nav.item :src_visit_plans, t("views.navigation.visit_plan.search", default: "Search"), visit_plans_url, class: "list-group-item"
        sub_nav.item :new_visit_plan, "New", new_visit_plan_path, class: "list-group-item", if: ->{can?(:create, VisitPlan)}
      end
    end
  end
end
