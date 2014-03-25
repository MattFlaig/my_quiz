Fabricator (:quiz) do
  quiz_name { Faker::Lorem.words(3).join(" ") }
  description { Faker::Lorem.words(9).join(" ") }
end