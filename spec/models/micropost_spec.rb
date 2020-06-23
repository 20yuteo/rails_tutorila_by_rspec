require 'rails_helper'
require 'spec_helper'

RSpec.describe Micropost, type: :model do
  let(:user) { FactoryBot.create(:user, activated: true) }
  let(:micropost) { FactoryBot.create(:micropost, user_id: user.id) }
  let(:most_recent) { FactoryBot.create(:most_recent, user_id: user.id) }
  let(:cat_video) { FactoryBot.create(:cat_video, user_id: user.id) }
  let(:tau_manifesto) { FactoryBot.create(:tau_manifesto, user_id:user.id) }
  let(:orange) { FactoryBot.create(:orange, user_id: user.id) }

  describe "microposts test" do

    it "is valid" do
      expect(micropost).to be_valid
    end

    it "is invalid without user_id" do
      micropost.user_id = nil
      expect(micropost).to_not be_valid
    end

    it "has contents" do
      micropost.content = " "
      expect(micropost).to_not be_valid
    end

    it "has contents with at most 140 characters" do
      micropost.content = "a" * 141
      expect(micropost).to_not be_valid
    end

    it "'s order is most recent first" do
      expect(most_recent).to eq Micropost.first
    end
  end
end
