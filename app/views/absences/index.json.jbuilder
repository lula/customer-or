json.array!(@absences) do |absence|
  json.id absence.id.to_s
  json.title absence.representative ? absence.representative.name : ""
  json.description "description"
	
	starts_at = absence.starts_at
	ends_at = absence.ends_at
	
	if absence.all_day == true
		starts_at = starts_at.strftime("%Y-%m-%d")
		ends_at = ends_at.strftime("%Y-%m-%d")
	end
			
	json.start starts_at
	json.end ends_at
	
	json.all_day absence.all_day
  json.recurring false
  json.url edit_absence_path(absence)
end