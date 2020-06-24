require 'rails_helper'
require 'rails-controller-testing'

RSpec.describe "Microposts", type: :request do
    let(:user) { FactoryBot.create(:user, activated: true, activated_at: Time.zone.now)}
    let(:other_user) { FactoryBot.create(:user, activated: true, activated_at: Time.zone.now) }
    let(:micropost) { FactoryBot.create(:orange, user_id: user.id) }

    context "when not logged in" do

        it "should be redirected create" do
            # binding.pry
            post microposts_path, params: { content: "Lorenm ipsum"}
            expect(response).to redirect_to login_url
        end

        it "should be redirected destroy" do
            # binding.pry
            delete micropost_path(micropost)
            expect(response).to redirect_to login_url
        end
    end

    context "wrong microposts" do
        it "should redirect destroy for" do
            sign_in_as(other_user)
            delete micropost_path(micropost)
            expect(response).to redirect_to root_url
        end
    end
end
