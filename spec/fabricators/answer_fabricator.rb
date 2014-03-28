Fabricator(:answer) do
  answer_text { Faker::Lorem.words(2).join(" ") }
end