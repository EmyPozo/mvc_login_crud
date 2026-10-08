User.find_or_create_by!(username: "admin") do |u|
  u.password = "admin123"
  u.password_confirmation = "admin123"
end