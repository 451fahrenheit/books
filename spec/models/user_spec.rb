require 'rails_helper'

#TODO regex email and password validations
RSpec.describe User, type: :model do
  let!(:user) { create(:user) }
  it "is valid with valid attributes" do
    user = User.new
    user.email="beta@incubyte.co"
    user.password_digest="alpha"
    expect(user).to be_valid
  end
  it "is invalid without email" do
    user = User.new
    expect(user).not_to be_valid
  end
  it "is invalid without password" do
    user = User.new
    user.password_digest=""
    user.email="alpha@incubyte.co"
    expect(user).not_to be_valid
  end
end
