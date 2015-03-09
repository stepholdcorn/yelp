require 'rails_helper'

feature 'restaurants' do
  context 'no restaurants have been added' do
    scenario 'should display a prompt to add a restaurant' do
      visit '/restaurants'
      expect(page).to have_content 'No restaurants'
      expect(page).to have_link 'Add restaurant'
    end
  end

  context 'restaurants have been added' do
    before do
      Restaurant.create(name: 'KFC')
    end

    scenario 'display restaurants' do
      visit '/restaurants'
      expect(page).to have_content('KFC')
      expect(page).not_to have_content('No restaurants yet!')
    end
  end

  context 'creating restaurants' do
    scenario 'prompts user to fill out a form, then displays the new restaurant' do
      sign_up('test@test.com', 'testtest', 'testtest')
      click_link 'Add restaurant'
      fill_in 'Name', with: 'KFC'
      click_button 'Create Restaurant'
      expect(page).to have_content('KFC')
      expect(current_path).to eq '/restaurants'
    end

    scenario 'is not permitted if the user is not logged in' do
      visit '/restaurants'
      click_link 'Add restaurant'
      expect(page).to have_content('You need to sign in or sign up before continuing')
    end
  end

  context 'an invalid restaurant' do
    it 'prevents a user submitting a name that is too short' do
      sign_up('test@test.com', 'testtest', 'testtest')
      click_link 'Add restaurant'
      fill_in 'Name', with: 'kf'
      click_button 'Create Restaurant'
      expect(page).not_to have_css 'h2', text: 'kf'
      expect(page).to have_content 'error'
    end
  end

  context 'viewing restaurants' do
    let!(:kfc){Restaurant.create(name: 'KFC')}

    scenario 'lets a user view a restaurant' do
      visit '/restaurants'
      click_link 'KFC'
      expect(page).to have_content 'KFC'
      expect(current_path).to eq "/restaurants/#{kfc.id}"
    end
  end

  context 'editing restaurants' do
    before {sign_up('test@test.com', 'testtest', 'testtest')
            click_link 'Sign out'}

    xscenario 'lets a user edit a restaurant' do
      sign_in('test@test.com', 'testtest')
      click_link 'Add restaurant'
      fill_in 'Name', with: 'KFC'
      click_button 'Create Restaurant'
      click_link 'Edit KFC'
      fill_in 'Name', with: 'Kentucky Fried Chicken'
      click_button 'Update Restaurant'
      expect(page).to have_content 'Kentucky Fried Chicken'
      expect(current_path).to eq '/restaurants'
    end

    scenario 'prevents a user editing a restaurant that is not their own' do
      sign_in('test@test.com', 'testtest')
      click_link 'Add restaurant'
      fill_in 'Name', with: 'The Ivy'
      click_button 'Create Restaurant'
      click_link 'Sign out'
      sign_up('steph@test.com', 'stephtest', 'stephtest')
      click_link 'Edit The Ivy'
      expect(page).to have_content('Restaurant cannot be edited')
    end

  end

  context 'deleting restaurants' do

    before {Restaurant.create name: 'KFC'}

    scenario 'removes a restaurant when a user clicks a delete link' do
      sign_up('test@test.com', 'testtest', 'testtest')
      click_link 'Delete KFC'
      expect(page).not_to have_content 'KFC'
      expect(page).to have_content 'Restaurant deleted successfully'
    end
  end

  def sign_in(email, password)
    visit '/users/sign_in'
    fill_in 'Email', with: email
    fill_in 'Password', with: password
    click_button 'Log in'
    visit '/restaurants'
  end

  def sign_up(email, password, password_conf)
    visit '/users/sign_up'
    fill_in 'Email', with: email
    fill_in 'Password', with: password
    fill_in 'Password confirmation', with: password_conf
    click_button 'Sign up'
    visit '/restaurants'
  end

end

