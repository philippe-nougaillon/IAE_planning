json.array!(@cours) do |cour|
  json.extract! cour, :id, :debut, :fin, :formation_json_v2, :matiere_json, :intervenant_json, :salle_json_v2
  # json.url cour_url(cour, format: :json)
end
