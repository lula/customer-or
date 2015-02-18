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
        
    if user_signed_in?
      
      # Users
      primary.item :users_menu, t("views.navigation.user.title", default: "Users"), admin_users_url, if: ->{can?(:read, User)}, highlights_on: /\/users/ do |sub_nav|
        sub_nav.dom_class = "nav navbar-nav"
        if current_user.admin?
          sub_nav.item :src_users, t("views.navigation.user.search", default: "Search"), admin_users_url
          sub_nav.item :new_user, t("views.navigation.user.new", default: "New"), new_admin_user_url, if: ->{can?(:create, User)} do |third_nav|
            third_nav.item :user_details, t("views.navigation.user.details", default: "Details"), "#user_details", has_anchor: true
          end
          
          if @user
            title = (@user.name && !@user.name.empty?) ? @user.name : @user.email
            sub_nav.item :selected_user, title, edit_admin_user_url(@user) do |third_nav|
              third_nav.item :user_details, t("views.navigation.user.details", default: "Details"), "#user_details", has_anchor: true
              third_nav.item :user_organizational_data, t("views.navigation.user.organizational_data", default: "Organizational Data"), "#user_organizational_data", has_anchor: true
            end
          end
          
        else 
          sub_nav.item :show_user, current_user.email, edit_admin_user_url(current_user),  if: ->{can?(:edit, User)} do |third_nav|
            third_nav.item :user_details, t("views.navigation.user.details", default: "Details"), "#user_details", has_anchor: true
            third_nav.item :user_organizational_data, t("views.navigation.user.organizational_data", default: "Organizational Data"), "#user_organizational_data", has_anchor: true
          end
        end
      end
      
      # Organizations
      primary.item :organizations, t("views.navigation.organization.title", default: "Organizations"), organizations_url,  if: ->{can?(:read, Organization)}, highlights_on: /\/organizations/ do |sub_nav|
        sub_nav.dom_class = "nav navbar-nav"
        sub_nav.item :src_organizations, t("views.navigation.organization.search", default: "Search"), organizations_url

        sub_nav.item :new_organization, t("views.navigation.organization.new", default: "New"), new_organization_url, if: ->{can?(:create, Organization)} do |third_nav|
          third_nav.item :organization_details, t("views.navigation.organization.details", default: "Details"), "#organization_details", has_anchor: true          
        end
                  
        if @organization && !@organization.new_record?
          edit_mode = request.url == edit_organization_url(@organization)
          url = edit_mode ? edit_organization_url(@organization) : organization_url(@organization)
        
          sub_nav.item :current_organization, @organization.name, url do |third_nav|
            third_nav.item :organization_details, t("views.navigation.organization.details", default: "Details"), "#organization_details", has_anchor: true
            third_nav.item :organization_customers, t("views.navigation.organization.customers", default: "Customers"), "#organization_customers", if: ->{!edit_mode}, has_anchor: true
            third_nav.item :organization_representatives, t("views.navigation.organization.representatives", default: "Representatives"), "#organization_representatives", if: ->{!edit_mode}, has_anchor: true
          end
        end
      end

      # Customers    
      primary.item :customers, t("views.navigation.customer.title", default: "Customers"), customers_url, if: ->{can?(:read, Customer)}, highlights_on: /\/customers/ do |sub_nav|
        sub_nav.dom_class = "nav navbar-nav"
        sub_nav.item :src_customers, t("views.navigation.customer.search", default: "Search"), customers_url

        sub_nav.item :new_customer, t("views.navigation.customer.new", default: "New"), new_customer_url, if: ->{can?(:create, Customer)}  do |third_nav|
          third_nav.item :customer_details, t("views.navigation.customer.details", default: "Details"), "#customer_details", has_anchor: true
          third_nav.item :customer_representative, t("mongoid.models.representative", default: "Representative"), "#customer_representative", has_anchor: true
          third_nav.item :customer_organizations, t("mongoid.models.organization", count: 2, default: "Organizations"), "#customer_organizations", has_anchor: true
        end
        
        if current_user.admin?
          sub_nav.item :import_customers, t("views.navigation.customer.import", default: "Import"), import_customers_url, if: ->{can?(:create, User)}
        end
        
        customer = @customer || @addressable
        if customer && !customer.new_record?
          edit_mode = request.url == edit_customer_url(customer)
          url = edit_mode ? edit_customer_url(customer) : customer_url(customer)
          
          sub_nav.item :current_customer, customer.name, url do |third_nav|
            third_nav.item :customer_details, t("views.navigation.customer.details", default: "Details"), "#customer_details", has_anchor: true
            third_nav.item :customer_addresses, t("mongoid.models.address", count: 2, default: "Addresses"), "#customer_addresses", if: ->{!edit_mode}, has_anchor: true
            third_nav.item :customer_business_hours, t("mongoid.models.business_hour", count: 2, default: "Business Hours"), "#customer_business_hours", has_anchor: true
            third_nav.item :customer_representative, t("mongoid.models.representative", default: "Representative"), "#customer_representative", if: ->{edit_mode}, has_anchor: true
            third_nav.item :customer_organizations, t("mongoid.models.organization", count: 2, default: "Organizations"), "#customer_organizations", has_anchor: true
            third_nav.item :customer_visits, t("mongoid.models.visit", count: 2, default: "Visits"), "#customer_visits", if: ->{!edit_mode}, has_anchor: true
          end
        end
      end

      # Representatives
      primary.item :representative_menu, t("views.navigation.representative.title", default: "Representatives"), representatives_url,  if: ->{can?(:read, Representative)}, highlights_on: /\/representatives/ do |sub_nav|
        sub_nav.dom_class = "nav navbar-nav"
        sub_nav.item :src_rep, t("views.navigation.representative.search", default: "Search"), representatives_url
        sub_nav.item :new_rep, t("views.navigation.representative.new", default: "New"), new_representative_url,  if: ->{can?(:create, Representative)} do |third_nav|
          third_nav.item :representative_details, t("views.navigation.representative.details", default: "Details"), "#representative_details", has_anchor: true
          third_nav.item :representative_organizations, t("views.navigation.representative.organizations", default: "Organizations"), "#representative_organizations", has_anchor: true
        end
        
        sub_nav.item :absences, t("views.navigation.representative.absences", default: "Absences"), absences_url
        
        if @representative && !@representative.new_record?
          edit_mode = request.url == edit_representative_url(@representative)
          url = edit_mode ? edit_representative_url(@representative) : representative_url(@representative)

          sub_nav.item :current_representative, @representative.name, url do |third_nav|
            third_nav.item :representative_details, t("views.navigation.representative.details", default: "Details"), "#representative_details", has_anchor: true
            third_nav.item :representative_organizations, t("views.navigation.representative.organizations", default: "Organizations"), "#representative_organizations", has_anchor: true
            third_nav.item :representative_customers, t("views.navigation.representative.customers", default: "Customers"), "#representative_customers", if: ->{!edit_mode}, has_anchor: true
            third_nav.item :representative_visits, t("views.navigation.representative.visits", default: "Visits"), "#representative_visits", if: ->{!edit_mode}, has_anchor: true
          end
        end        
      end

      # Visits
      primary.item :visits, t("views.navigation.visit.title", default: "Visits"), visits_url,   if: ->{can?(:read, Visit)}, highlights_on: /\/visits/ do |sub_nav|
        sub_nav.dom_class = "nav navbar-nav"
        sub_nav.item :srcvisits, t("views.navigation.visit.search", default: "Search"), visits_url
        sub_nav.item :new_visit, t("views.navigation.visit.new", default: "New"), new_visit_url,  if: ->{can?(:create, Visit)}
      end

      # Visit Plans
      primary.item :visit_plans,  t("views.navigation.visit_plan.title", default: "Visit Plan"), visit_plans_url,  if: ->{can?(:read, Visit)}, highlights_on: /\/visit_plans/ do |sub_nav|
        sub_nav.dom_class = "nav navbar-nav"
        sub_nav.item :src_visit_plans, t("views.navigation.visit_plan.search", default: "Search"), visit_plans_url
        sub_nav.item :new_visit_plan, "New", new_visit_plan_path,  if: ->{can?(:create, VisitPlan)}
      end
    end
  end
end
