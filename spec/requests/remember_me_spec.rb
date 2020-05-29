require 'rails_helper'
require './spec/support/utilities.rb'

RSpec.describe "Remember me", type: :request do
    let(:user) { FactoryBot.create(:user, activated: true, activated_at: Time.zone.now) }

    context "with vaild information" do
        it "logs in with valid informaiton" do
            sign_in_as(user)
            expect(response).to redirect_to user_path(user)

            delete logout_path
            expect(response).to redirect_to root_path
            expect(session[:user_id]).to eq nil

            delete logout_path
            expect(response).to redirect_to root_path
            expect(session[:user_id]).to eq nil
        end
    end

    context "login with remembering" do
        it "remembers cookies" do
          post login_path, params: { session: { email: user.email,
                                          password: user.password,
                                          remember_me: '1'} }
          expect(response.cookies['remember_token']).to_not eq nil
        end
      end

      context "login without remembering" do
        it "doesn't remember cookies"do
          # クッキーを保存してログイン
          post login_path, params: { session: { email: user.email,
                                          password: user.password,
                                          remember_me: '1'} }
          delete logout_path
          # クッキーを保存せずにログイン
          post login_path, params: { session: { email: user.email,
          password: user.password,
          remember_me: '0'} }
          expect(response.cookies['remember_token']).to eq nil
      end
    end
end
