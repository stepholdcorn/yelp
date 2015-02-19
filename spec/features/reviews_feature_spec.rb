require 'rails_helper'

feature 'reviewing' do
  before {Restaurant.create name: 'KFC'}

  scenario 'allows user to leave a review using a form' do
    sign_up
    leave_review('so so', 3)
    expect(current_path).to eq '/restaurants'
    expect(page).to have_content('so so')
  end

  scenario 'prevents user leaving a review unless they are signed in' do
    visit '/restaurants'
    click_link 'Review KFC'
    expect(page).to have_content('You need to sign in or sign up before continuing')
  end

  scenario 'displays an average rating for all reviews' do
    sign_up
    leave_review('So so', '3')
    leave_review('Great', '5')
    expect(page).to have_content('Average rating: 4')
  end

end

def leave_review(thoughts, rating)
  visit '/restaurants'
  click_link 'Review KFC'
  fill_in 'Thoughts', with: thoughts
  select rating, from: 'Rating'
  click_button 'Leave Review'
end

def sign_up
  visit '/users/sign_up'
  fill_in 'Email', with: 'test@test.com'
  fill_in 'Password', with: 'testtest'
  fill_in 'Password confirmation', with: 'testtest'
  click_button 'Sign up'
end
