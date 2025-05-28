json.user do
  json.id @current_user.id
  json.email @current_user.email

  json.stats do
    json.total_games_played @current_user.games_played
  end
end