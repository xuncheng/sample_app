require 'spec_helper'

describe User do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should validate_presence_of(:password_confirmation) }
  it { should validate_uniqueness_of(:email) }
  it { should have_many(:microposts).dependent(:destroy) }

  it "deletes microposts associated with user" do
    user = Fabricate(:user)
    micropost = Fabricate(:micropost, user: user)
  end

  it "#feed" do
    user = Fabricate(:user)
    micropost1 = Fabricate(:micropost, user: user)
    micropost2 = Fabricate(:micropost, user: user)
    expect(user.feed).to match_array([micropost1, micropost2])
  end
end
