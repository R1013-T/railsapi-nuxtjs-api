10.times do |n|
  name = "user#{n}"
  email = "#{name}@example.com"
  user = User.find_or_initialize_by(email: email, activated: true)

  if user.new_record?
    user.name = name
    user.password = "password"
    user.save!
  end
end

# 管理者を追加
admin = User.find_or_initialize_by(email: "admin@example.com", activated: true)
if admin.new_record?
  admin.name = "admin"
  admin.password = "password"
  admin.admin = true
  admin.role = "manager"
  admin.permission = "admin"
  admin.save!
end

puts "users = #{User.count}"