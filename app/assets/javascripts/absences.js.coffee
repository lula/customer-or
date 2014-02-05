# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

calendar = null
starts_at = new Date()
ends_at = new Date()
all_day = true

updateEvent = (event) ->	
	starts_at = event.start
	ends_at = if event.end then event.end else starts_at

	$.update "/absences/" + event.id,
		absence:
			starts_at: "" + starts_at
			ends_at: "" + ends_at
  , (reponse) ->
    # alert "successfully updated task."

createEvent = (start_date, end_date, allDay) ->
	representative_id = $(".popover-content select").val()	
	return false if not representative_id
	
	# d = ("0" + start_date.getDate()).slice(-2)
	# m = ("0" + (start_date.getMonth() + 1)).slice(-2)
	# y = start_date.getFullYear()
	# starts_at = y + "-" + m + "-" + d
	# 
	# d = ("0" + end_date.getDate()).slice(-2)
	# m = ("0" + (end_date.getMonth() + 1)).slice(-2)
	# y = end_date.getFullYear()
	# ends_at = y + "-" + m + "-" + d
	#  	
	hours = start_date.getHours()
	
	if allDay
		minutes = "0"
		timeStr = ""
	else
		minutes = start_date.getMinutes()
		timeStr = (if hours < 10 then "0" + hours else hours) + ":"
		timeStr += if minutes < 10 then "0" + minutes else minutes
		timeStr += " "
	
	title = timeStr + $(".popover-content select option:selected").text()

	$.create "/absences",
		absence:
			starts_at: "" + start_date
			ends_at: "" + end_date
			representative_id: "" + representative_id
			all_day: allDay
 	, (reponse) ->
		calendar.fullCalendar "refetchEvents"
		# calendar.fullCalendar "renderEvent",
		# 	title: title
		# 	start: start_date
		# 	end: end_date
		# 	allDay: allDay
		# 	color: "red",
		# 	true
		$(".popover.in").remove()
	
	# $('#calendar').fullCalendar('dayClick', start_date, start_date, jsEvent, view)
	# window.location = "/absences/new?starts_at=" + starts_at + "&ends_at=" + ends_at	

ready = ->  	
	$(this).on "click", "#absence_qs_save_btn", () ->
		createEvent starts_at, ends_at, all_day
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
		
		timeFormat: "HH:mm { - HH:mm } "
		dragOpacity: "0.5"

		eventDrop: (event, dayDelta, minuteDelta, allDay, revertFunc) ->
			updateEvent event

		eventResize: (event, dayDelta, minuteDelta, revertFunc) ->
			updateEvent event

		# eventClick: (event, jsEvent, view) ->
		# 	alert "click"	
		
		select: (startDate, endDate, allDay, jsEvent, view) ->
			starts_at = startDate
			ends_at = endDate
			all_day = allDay
			
			d = ("0" + starts_at .getDate()).slice(-2)
			m = ("0" + (starts_at .getMonth() + 1)).slice(-2)
			y = starts_at .getFullYear()
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