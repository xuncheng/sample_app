Fabricator(:micropost) do
  content { Faker::Lorem.sentence(5) }
end
