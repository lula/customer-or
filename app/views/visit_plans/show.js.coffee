$("#visit-plan-table").html("<%= escape_javascript(render 'visits') %>")
$(".bootstrap-flash").html("<%= escape_javascript(render 'layouts/bootstrap_flash') %>")