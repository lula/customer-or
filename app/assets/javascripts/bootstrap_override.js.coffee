jQuery ->
  # $("a[rel~=popover], .has-popover").popover()
  # $("a[rel~=tooltip], .has-tooltip").tooltip()
	$(this)
		.on "mouseenter", "button[rel~=tooltip], a[rel~=tooltip], .has-tooltip", (event) ->
			$(@).tooltip()
		.on "click", "a[rel~=popover], .has-popover", (event) -> 
			$(@).popover()
		
		.on "click", "tr[selectable]", (event) ->
			check_box = $(@).find("input[type=checkbox]")
			checked = !check_box.prop("checked")
			check_box.prop("checked", checked)

			if checked
				$(@).closest("[selectable]").attr("selectable", "selected")
				$(@).find("td:first-child .selection-icon").html("<i class='fa fa-check'/>")
			else
				$(@).closest("[selectable]").attr("selectable", "")
				$(@).find("td:first-child .selection-icon").html("") # <i class='fa fa-check-empty'/>

		.on "click", "th a.select-all", (event) ->
			table = $(@).parents("table")
			table.find("input[type=checkbox]").each ->

				checked = !$(@).prop("checked")
				$(@).prop("checked", checked)

				if checked
					$(@).closest("[selectable]").attr("selectable", "selected")
					table.find("td:first-child .selection-icon").html("<i class='fa fa-check'/>")
				else
					$(@).closest("[selectable]").attr("selectable", "")
					table.find("td:first-child .selection-icon").html("") # <i class='fa fa-check-empty'/>
			false
		
		.on "click", ".panel-collapse", (event) -> 
			if $(@).find("i").attr("class") == "fa fa-chevron-up"
				$(@).html("<i class='fa fa-chevron-down'></i>")
			else
				$(@).html("<i class='fa fa-chevron-up'></i>")
		
		.on "click", "[data-hide]", (event) ->
			$($(@).attr("data-hide")).hide()	
		
		.on "click", "[data-show]", (event) ->
			$($(@).attr("data-show")).show()
		
		.on "change", "#user_representative_id", (event) ->
			if $(@).val() != ""
				$("#organization-select").hide()
			else
				$("#organization-select").show()
		
		.on "change", "#organization-select", (event) ->
			if $(@).find(".select2-container .select2-search-choice").length == 0
				$("#representative-select").show()
			else
				$("#representative-select").hide()
				
		