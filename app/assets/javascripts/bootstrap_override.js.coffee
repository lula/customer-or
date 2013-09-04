jQuery ->
  # $("a[rel~=popover], .has-popover").popover()
  # $("a[rel~=tooltip], .has-tooltip").tooltip()
	$(this)
		.on "mouseenter", "a[rel~=tooltip], .has-tooltip", (event) ->
			$(@).tooltip()
		.on "click", "a[rel~=popover], .has-popover", (event) -> 
			$(@).popover()
		
		.on "click", "tr[selectable]", (event) ->
			check_box = $(@).find("input[type=checkbox]")
			checked = !check_box.prop("checked")
			check_box.prop("checked", checked)

			if checked
				$(@).find("td:first-child .selection-icon").html("<i class='icon-check'/>")
			else
				$(@).find("td:first-child .selection-icon").html("<i class='icon-check-empty'/>")

		.on "click", "th a.select-all", (event) ->
			table = $(@).parents("table")
			table.find("input[type=checkbox]").each ->

				checked = !$(@).prop("checked")
				$(@).prop("checked", checked)

				if checked
					table.find("td:first-child .selection-icon").html("<i class='icon-check'/>")
				else
					table.find("td:first-child .selection-icon").html("<i class='icon-check-empty'/>")
			false
		
		.on "click", ".panel-collapse", (event) -> 
			if $(@).find("i").attr("class") == "icon-chevron-sign-up"
				$(@).html("<i class='icon-chevron-sign-down'></i>")
			else
				$(@).html("<i class='icon-chevron-sign-up'></i>")