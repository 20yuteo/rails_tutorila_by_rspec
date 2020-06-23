require 'rails_helper'

RSpec.describe 'user profile', type: :system do

    let!(:user) { FactoryBot.create(:user, activated: true) }
    let!(:micropost) { FactoryBot.create(:micropost, user_id: user.id) }

    context 'profile display' do
        before { visit user_path(user) }
        subject { page }
        it 'has correct template' do
            is_expected.to have_title full_title(user.name)
            is_expected.to have_selector 'h1', text: user.name
            is_expected.to have_selector 'h1>img.gravatar'
            microposts = user.microposts.count.to_s
            is_expected.to have_selector 'h3', text: "Microposts" + " (" + microposts + ")"
            # is_expected.to have_css 'div.pagination'
            # assert_select 'div.pagination'
            user.microposts.paginate(page: 1).each do |micropost|
            assert_match micropost.content, page.body
            end
        end
    end
end
