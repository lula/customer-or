jQuery ->
  $("a[rel~=popover], .has-popover").popover()
  # $("a[rel~=tooltip], .has-tooltip").tooltip()
	.on "mouseenter", "a[rel~=tooltip], .has-tooltip", (event) ->
		$(@).tooltip()
	.on "click", "tr[selectable]", (event) ->
		check_box = $(@).find("input[type=checkbox]")
		checked = !check_box.prop("checked")
		check_box.prop("checked", checked)

		if checked
			$(@).find("td:first-child .selection-icon").html("<i class='icon-check'/>")
		else
			$(@).find("td:first-child .selection-icon").html("<i class='icon-check-empty'/>")
	.on "click", "th a.select-all", (event) ->
		$(@).parents("table").find("input[type=checkbox]").each -> 
			checked = !$(@).prop("checked")
			$(@).prop("checked", checked)
			
			if checked
				$(@).find("table").find("td .selection-icon").html("<i class='icon-check'/>")
			else
				$(@).find("table").find("td .selection-icon").html("<i class='icon-check-empty'/>")
			