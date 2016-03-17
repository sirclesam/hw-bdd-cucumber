# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    
    if( Movie.where(title: movie[:title]).exists?)
      #do nothing, movie exists in DB already
    else
      Movie.create!(movie)
    end
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  regexp = /#{e1}.*#{e2}/m #  /m means match across newlines
  page.body.should =~ regexp
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  rating_list = rating_list.split(" ")
  
  rating_list.each do | rating |
    rating = "ratings_#{rating}"
    if(uncheck)
      uncheck(rating)
    else
      check(rating)
    end
  end
end

When /I uncheck all ratings checkboxes/ do
    checkbox_ids = ["ratings_G" ,"ratings_PG","ratings_R","ratings_PG-13","ratings_NC-17"]
    checkbox_ids.each do |checkbox_id|
      uncheck(checkbox_id)
    end
end

Then /I should see all the movies/ do
  total_movies = Movie.all.count
  movies_shown = page.all('table#movies tr').count
  movies_shown.should == total_movies + 1 #Header row adds 1
end

