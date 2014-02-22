# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

calendar = null
starts_at = null
ends_at = null
current_view = null

updateEvent = (event, revertFunc, jsEvent, ui, view) ->
	starts_at = event.start
	ends_at = if event.end then event.end else starts_at
	all_day = false
	
	if view.name == "month"
		all_day = true
		starts_at.stripTime()
		ends_at.stripTime()
	
	$.update "/absences/" + event.id,
		absence:
			starts_at: "" + starts_at.toDate()
			ends_at: "" + ends_at.toDate()
			all_day: all_day
  , (reponse) ->
    # alert "successfully updated task."

createEvent = (start_date, end_date) ->
	representative_id = $(".popover-content select").val()	
	return false if not representative_id
		
	all_day = false
	
	if current_view.name == "month"
		all_day = true
		start_date.stripTime()

	$.create "/absences",
		absence:
			starts_at: "" + start_date.toDate()
			ends_at: "" + end_date.toDate()
			representative_id: "" + representative_id
			all_day: all_day
 	, (reponse) ->
		calendar.fullCalendar "refetchEvents"
		# calendar.fullCalendar "renderEvent",
		# 	title: title
		# 	start: start_date
		# 	end: end_date
		# 	color: "red",
		# 	true
		$(".popover.in").remove()
	
ready = ->  	
	$(this).on "click", "#absence_qs_save_btn", () ->
		createEvent starts_at, ends_at
		false
	
	$(this).on "click", "#absence_qs_cancel_btn", () ->
		$(".popover.in").remove()
		false
	
	calendar = $("#calendar").fullCalendar
		selectable: true
		selectHelper: true
		editable: true
		header:
			left: "prev,next today"
			center: "title"
			right: "month,agendaWeek,agendaDay"
		defaultView: "month"
		height: 600
		slotMinutes: 15
		
		loading: (bool) ->
			if bool
				#$("#loading").show()
			else
				#$("#loading").hide()

		eventSources: [
			url: "/absences"
			color: "red"
			textColor: "#fefefe"
			ignoreTimezone: false
		]
		
		# timeFormat: "HH:mm { - HH:mm } "
		dragOpacity: "0.5"

		eventDrop: (event, revertFunc, jsEvent, ui, view) ->
			updateEvent event, revertFunc, jsEvent, ui, view

		eventResize: (event, revertFunc, jsEvent, ui, view) ->
			updateEvent event, revertFunc, jsEvent, ui, view

		# eventClick: (event, jsEvent, view) ->
		# 	alert "click"	
		
		select: (start, end, jsEvent, view) ->		
			starts_at = start
			ends_at = end
			current_view = view
			
			d = ("0" + starts_at.date()).slice(-2)
			m = ("0" + (starts_at.month() + 1)).slice(-2)
			y = starts_at.year()
			el_date = y + "-" + m + "-" + d
			el = "td[data-date='" + el_date + "']"
						
			$(el).popover
				container: "body"
				placement: "top"
				html: true
				title: ""
				content: $("#popover").html()
	
			$(".popover.in").remove()
			$(el).popover("show")

$(document).ready(ready);
$(document).on('page:load', ready);