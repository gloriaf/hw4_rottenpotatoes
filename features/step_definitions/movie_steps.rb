# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create!(movie)
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
  end
end

Then /I should see (none|all) of the movies/ do |sel|
  db_size = 0
  db_size = Movie.all.size
  if sel == "all"
    page.find(:xpath, "//table[@id=\"movies\"]/tbody[count(tr) = #{db_size} ]")
  end
end

Then /the director of "(.*)" should be "(.*)"/ do |a1, a2|
  assert page.body =~ /#{a1}.+Director.+#{a2}/m
end

