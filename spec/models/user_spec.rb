require 'rails_helper'

RSpec.describe User, type: :model do
  before(:example) do
    # build returns a User instance that's not saved - create returns a saved user
    @user = build(:user)
  end

  it 'is valid with number of users increased by one' do
    count = User.all.count
    create(:user)
    expect(User.all.count).to eq(count + 1)
  end

  it 'is valid with valid attributes' do
    expect(@user).to be_valid
  end

  it 'is invalid with null username' do
    @user.username = nil
    expect(@user).to_not be_valid
  end

  it 'is invalid with username containing "@"' do
    @user.username = 'user@'
    expect(@user).to_not be_valid
  end

  it 'is invalid with username equal an already taken username' do
    @user.save # it was built now it saves in the db
    user2 = build(:user, username: @user.username, email: 'bob@gmail.com', password: '123456')
    expect(user2).to_not be_valid
  end

  it 'is invalid with username equal an already taken email' do
    @user.save # it was built now it saves in the db
    user2 = build(:user, username: @user.email, email: 'bob@gmail.com', password: '123456')
    expect(user2).to_not be_valid
  end

  it 'is invalid with null email' do
    @user.email = nil
    expect(@user).to_not be_valid
  end

  it 'is invalid with email equal an already taken email' do
    @user.save # it was built now it saves in the db
    user2 = build(:user, username: 'bob', email: @user.email, password: '123456')
    expect(user2).to_not be_valid
  end

  it 'is invalid with email using wrong format' do
    @user.email = 'aaaaa@asasdas...com'

    expect(@user).to_not be_valid
  end

  it 'is invalid with invalid password' do
    @user.password = 'abc'
  end

end
