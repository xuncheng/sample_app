require 'spec_helper'

describe Micropost do
  it { should belong_to(:user) }
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:content) }
  it { should validate_presence_of(:content) }
  it { should ensure_length_of(:content).is_at_most(140) }

  it "microposts descending order of creation date" do
    user = Fabricate(:user)
    micropost1 = Fabricate(:micropost, user_id: user.id, created_at: 1.day.ago)
    micropost2 = Fabricate(:micropost, user_id: user.id)
    expect(Micropost.all).to eq([micropost2, micropost1])
  end
end
