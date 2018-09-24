# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.destroy_all
#Profile.destroy_all
#TodoList.destroy_all
#TodoItem.destroy_all

due_date = Date.today + 1.year

Profile.create! [
  { first_name: "Carly",   last_name: "Fiorina", birth_year: 1954, gender: "female" },
  { first_name: "Donald",  last_name: "Trump",   birth_year: 1946, gender: "male" },
  { first_name: "Ben",     last_name: "Carson",  birth_year: 1951, gender: "male" },
  { first_name: "Hillary", last_name: "Clinton", birth_year: 1947, gender: "female" }
]

profiles = Profile.all

profiles.each do |profile|
  profile.create_user( username: profile.last_name, password_digest: profile.birth_year )
  profile.user.todo_lists.create!(list_name: profile.first_name, list_due_date: due_date )
end

todolists = TodoList.all

todolists.each do |list|
  5.times do
  list.todo_items.create!(due_date: due_date, title: "Title", description: "Description")
  end
end


# people = {"Carly Fiorina female" => 1954, "Donald Trump male" => 1946, "Ben Carson male" => 1951, "Hillary Clinton female" => 1947}
# tdi = {"pen" => "write a letter", "toothbrush" => "clean the teeth", "computer" => "make a homework", "food" => "eat it!", "paper" => "make a glider"}

# people.each do |key, value|
#   User.create username: key.split(" ")[1], password_digest: key.split(" ")[1]
#   usr = User.find_by username: key.split(" ")[1]
#   usr.profile = Profile.create gender: key.split(" ")[2], birth_year: value, first_name: key.split(" ")[0], last_name: key.split(" ")[1]
#   usr.todo_lists << TodoList.create list_name: "#{key.split(" ")[0]}'s list", list_due_date: Date.today+1.year
#   tdl = TodoList.find_by list_name: "#{key.split(" ")[0]}'s list"
#   tdi.each do |item, desc|
#   	tdl.todo_items << TodoItem.create due_date: Date.today+1.year, title: item, descrition: desc
#   end
# end



# User.create! [
#   { username: "Fiorina", password_digest: "Fiorina" },
#   { username: "Trump", password_digest: "Trump" },
#   { username: "Carson", password_digest: "Carson" },
#   { username: "Clinton", password_digest: "Clinton" },
# ]

# Profile.create! [
#   { gender: "female", birth_year: 1954, first_name: "Carly", last_name: "Fiorina", user: "Fiorina" },
#   { gender: "male", birth_year: 1946, first_name: "Donald", last_name: "Trump", user: "Trump" },
#   { gender: "male", birth_year: 1951, first_name: "Ben", last_name: "Carson", user: "Carson" },
#   { gender: "female", birth_year: 1947, first_name: "Hillary", last_name: "Clinton", user: "Clinton" },
# ]

# TodoList.create! [
#   { },
# ]