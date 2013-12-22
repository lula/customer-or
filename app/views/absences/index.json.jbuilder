json.array!(@absences) do |absence|
  json.id absence.id.to_s
  json.title absence.representative ? absence.representative.name : ""
  json.description "description"
  json.start absence.starts_at.rfc822
  json.end absence.ends_at.rfc822
  json.allDay absence.all_day
  json.recurring false
  json.url edit_absence_path(absence)
end