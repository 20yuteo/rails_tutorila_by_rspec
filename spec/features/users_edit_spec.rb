require 'rails_helper'

RSpec.feature "Edit", type: :feature do
    let(:user) { FactoryBot.create(:user, activated: true, activated_at: Time.zone.now) }

    scenario "successful edit" do
        visit user_path(user)
        valid_login(user)
        click_link "Settings"

        fill_in "user_email", with: "edit@example.com"
        click_button "Save changes"

        expect(current_path).to eq user_path(user)
    end

    scenario "unsuccessful edit" do
        valid_login(user)
        visit user_path(user)
        click_link "Settings"
# debugger
        fill_in "user_email", with: "foo@invalid"
        fill_in "user_password", with: "foo", match: :first
        fill_in "user_password_confirmation", with:"bar"
        click_button "Save changes"

        expect(user.reload.email).to_not eq "foo@invalid"
    end
end