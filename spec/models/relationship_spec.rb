require 'rails_helper'

RSpec.describe Relationship, type: :model do

  let!(:user) { FactoryBot.create(:user, activated: true, activated_at: Time.zone.now) }
  let(:other_user) { FactoryBot.create(:user, name: 'other user', activated: true, activated_at: Time.zone.now) }
  let(:relationship) { FactoryBot.create(:relationship, follower_id: user.id, followed_id: other_user.id)}

  context 'relationship test' do
    it 'is valid relationship' do
      expect(relationship).to be_valid
    end

    it 'is invalid relationship without follower id' do
      relationship.follower_id = nil
      expect(relationship).to_not be_valid
    end

    it 'is invalid relationship without followed id' do
      relationship.followed_id = nil
      expect(relationship).to_not be_valid
    end
  end
end
