require 'rails_helper'

RSpec.describe 'following test', type: :system do

    let!(:user) { FactoryBot.create(:user, activated: true, activated_at: Time.zone.now) }
    let!(:other_user) { FactoryBot.create(:user, name: 'other_user', activated: true, activated_at: Time.zone.now) }
    let!(:relationship_by_following) { FactoryBot.create(:relationship, follower_id: user.id, followed_id: other_user.id)}
    let!(:relationship_by_followed) { FactoryBot.create(:relationship, follower_id: other_user.id, followed_id: user.id)}

    # subject { log_in_as(user) }

    it 'is a following page' do
        log_in_as(user)
        click_link 'following'
        users_num = user.following.count.to_s
        expect(page.body).to include users_num
        expect(page).to have_link other_user.name
    end

    it 'is a foloowed page' do
        log_in_as(user)
        click_link 'followers'
        users_num = user.followers.count.to_s
        expect(page.body).to include users_num
        expect(page).to have_link other_user.name
    end

    it 'is followed by user at the standard way' do
        log_in_as(user)
        click_link 'Users'
        click_link 'other_user'
        click_button 'Unfollow'
        users_num = user.following.count.to_s
        expect(page.body).to include users_num
    end
  end