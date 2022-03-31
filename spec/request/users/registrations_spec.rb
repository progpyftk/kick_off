require 'rails_helper'

''"
If you are used to writing controller specs, you are probably comfortable with the `have_selector matcher.
However, in request specs this matcher is not available. By default, you can only do text search inside the
request body which leads to brittle assertions.
You can add the have_selector matcher by updating your RSpec config to include the Capybara matchers on request specs as well.
RSpec.configure do |config|
  config.include Capybara::RSpecMatchers, type: :request
end
Then you can write more confident Request specs by using assertions like
expect(response.body).to have_selector('ul li', text: 'List content here!')
"''

RSpec.describe '/users', type: :request do
  let(:valid_attributes) do
    { email: 'test@test.com',
      username: 'testuser',
      password: 'foobar',
      password_confirmation: 'foobar' }
  end

  let(:invalid_attributes) do
    { email: 'test@test.com',
      username: '',
      password: 'foobar',
      password_confirmation: 'foobar' }
  end

  let(:user) { create(:user) }

  describe 'GET /new' do
    it 'renders a successful response' do
      get new_user_registration_path
      expect(response).to be_successful
    end
  end

  describe 'GET /edit' do
    it 'render a successful response' do
      sign_in user
      get edit_user_registration_path(user)
      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new User' do
        expect do
          post '/users', params: { user: valid_attributes }
        end.to change(User, :count).by(1)
      end

      it 'redirects to the root path' do
        post '/users', params: { user: valid_attributes }
        expect(response).to redirect_to(root_path)
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new User and renders the form' do
        expect do
          post '/users', params: { user: invalid_attributes }
        end.to change(User, :count).by(0)
        expect(response).to be_successful
        expect(response).to render_template(:new)
        expect(response.body).to include('<p class="alert"></p>')
      end
    end
  end

  describe 'PATCH /update' do
    context 'with valid params' do
      let(:new_valid_attributes) do
        { email: 'updated@test.com',
          username: 'updateduser',
          password: 'updatedfoobar',
          password_confirmation: 'updatedfoobar',
          current_password: '123456' }
      end

      it 'updates the requested user' do
        sign_in user
        patch '/users', params: { user: new_valid_attributes }
        follow_redirect!
        user.reload
        expect(user.username).to eq(new_valid_attributes[:username])
      end
    end

    context 'with invalid params' do
      let(:new_invalid_attributes) do
        { email: 'updated@test.com',
          username: 'updateduser',
          password: 'updatedfoobar',
          password_confirmation: 'updatedfoobar',
          current_password: 'wrongpassword' }
      end

      it 'updates the requested article' do
        sign_in user
        patch '/users', params: { user: new_invalid_attributes }
        expect(response).to render_template(:edit)
        expect(response.body).to include('<p class="alert"></p>')
        expect(user.username).not_to eq(new_invalid_attributes[:username])
      end
    end
  end
end
