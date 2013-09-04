$("#addresses-table").html('<%= escape_javascript(render "layouts/grid", grid: @addresses_grid, assets: @addresses, path: @customer, pagination_param_name: "addresses_page", starred: :is_main?, html: { class: "table table-condensed table-hover" }) %>')
$("#visits-table").html("<%= escape_javascript(render 'layouts/grid', grid: @visits_grid, assets: @visits, pagination_param_name: 'visits_page', remote: true) %>")
$("#organizations-table").html("<%= escape_javascript(render 'layouts/grid', grid: @organizations_grid, assets: @organizations, pagination_param_name: 'organizations_page', remote: true) %>")