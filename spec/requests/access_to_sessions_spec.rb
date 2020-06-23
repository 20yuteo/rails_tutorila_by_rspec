require 'rails_helper'

RSpec.describe 'access to sessions', type: :request do
  let!(:user) { create(:user, activated: true, activated: true, activated_at: Time.zone.now) }
  describe 'POST #create' do
    it 'log in and redirect to detail page' do
      post login_path, params: { session: { email: user.email,
                                            password: user.password } }
      expect(response).to redirect_to user_path(user)
      expect(is_logged_in?).to be_truthy #ログインしているかのテストここでis_logged_in?を使ってます。
    end
  end

  describe 'DELETE #destroy' do
    it 'log out and redirect to root page' do
        delete logout_path
        expect(response).to redirect_to root_path
        expect(is_logged_in?).to be_falsey
    end
  end
end