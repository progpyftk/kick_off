# https://stackoverflow.com/questions/49910032/difference-between-feature-spec-and-system-spec

# good pages for learning capybara:
# https://semaphoreci.com/community/tutorials/5-tips-for-more-effective-capybara-tests

require 'rails_helper'

RSpec.describe 'User registration', type: :system do
  describe 'User registration' do
    let(:user_email) { 'registration_test_user@example.org' }
    let(:user_password) { 'registration_test_password' }
    let(:user_username) { 'registration_test_username' }

    it 'shows message about confirmation email' do
      visit new_user_registration_path
      fill_in 'user_email', with: user_email
      fill_in 'user_password', with: user_password
      fill_in 'user_password_confirmation', with: user_password
      fill_in 'user_username', with: user_username
      within('.actions') do
        click_button 'Sign up', exact: true
      end
      expect(page).to have_content('A message with a confirmation link has been sent to your email address.')
    end

    it 'renders form again when filled with wrong info' do
      visit new_user_registration_path
      fill_in 'user_email', with: user_email
      fill_in 'user_password', with: user_password
      fill_in 'user_password_confirmation', with: user_password
      fill_in 'user_username', with: ""
      within('.actions') do
        click_button 'Sign up', exact: true
      end
      expect(page).to have_content('error prohibited this user from being saved')
    end
  end
end
