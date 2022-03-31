require 'rails_helper'

# http://rubyblog.pro/2017/10/rspec-difference-between-mocks-and-stubs

# Capybara docs: Capybara matchers are also supported in view specs
# od métodos como have_selector, have_css ... sao do Capybara

RSpec.describe 'users/registrations/new', type: :view do
  before do
    without_partial_double_verification do
      allow(view).to receive(:resource).and_return(create(:user))
      allow(view).to receive(:resource_name).and_return(:user)
      allow(view).to receive(:devise_mapping).and_return(Devise.mappings[:user])
    end
  end
  it 'contains the username field on form registration view' do
    puts render
    expect(rendered).to match /Username/
    expect(rendered).to have_css('.field', count: 4)
  end
end
