Fabricator(:category) do
  category_name { Faker::Lorem.words(1).join(" ") }
end