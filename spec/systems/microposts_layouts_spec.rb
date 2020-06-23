require 'rails_helper'

RSpec.describe 'microposts layouts', type: :system do

    let!(:user) { FactoryBot.create(:user, activated: true, activated_at: Time.zone.now) }
    let!(:micropost) { FactoryBot.create(:micropost, user_id: user.id) }
    let(:other_user) { FactoryBot.create(:user, name: 'other user', activated: true, activated_at: Time.zone.now) }

    before { log_in_as(user) }
    context 'layouts test' do
        it 'is invalid requests' do
            click_link 'Home'
            fill_in 'micropost_content', with: ''
            click_button 'Post'
            expect(page).to have_selector('#error_explanation')
        end

        it 'is valid requests' do
            click_link 'Home'
            fill_in 'micropost_content', with: 'This micropost really ties the room together'
            click_button 'Post'
            expect(page).to have_current_path root_path
            # follow_redirect!
            assert_match micropost.content, page.body
        end

        it 'is valid delete' do
            page.accept_confirm do
                click_link 'delete'
            end
            # microposts = user.microposts.count.to_s
            expect(page).to have_selector('.alert-success')
        end

        it 'is invalid delete' do
            click_link 'Users'
            click_link other_user.name
            expect(page).to_not have_content 'delete'
        end

        it 'is invalid request include a picture' do
            click_link 'Home'
            # expect(page).to have_selector 'div.pagination'
            expect(page).to have_selector 'input[type=file]'
            fill_in 'micropost_content', with: 'This micropost really ties the room together'
            image_path = File.join(Rails.root, "spec/fixtures/rails.png")
            attach_file "micropost[picture]", image_path
            # page.('#micropost_picture').set(image_path)
            # update_profile(page)
            click_button 'Post'
            expect(page).to have_content("This micropost really ties the room together")
        end
    end
end