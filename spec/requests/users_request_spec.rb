require 'rails_helper'
require 'rails-controller-testing'

RSpec.describe "Users", type: :request do
  let(:user) { FactoryBot.create(:user, activated: true, activated_at: Time.zone.now) }
  # admin_user = build(:admin_user)
  let(:admin_user) { FactoryBot.create(:user, admin: true, activated: true, activated_at: true) }
  let(:other_user) { FactoryBot.create(:user, activated_at: Time.zone.now) }

  describe "GET /new" do
    it "returns http success" do
      get "/signup"
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST #create" do

    context 'valid request' do
      it 'adds a user' do
        expect do
          post signup_path, params: { user: attributes_for(:user) }
        end.to change(User, :count).by(1)
      end

    context 'add a user' do
        before { post signup_path, params: { user: attributes_for(:user) } }
        subject { response }
        it { is_expected.to redirect_to root_path }
        it { is_expected.to have_http_status 302 }
        it 'Log in' do
          expect(is_logged_in?).to be_falsy
        end
    end
  end

    context 'invalid request' do
      let(:user_params) do
        attributes_for(:user, name: '',
                              email: 'user@invalid',
                              password: '',
                              password_confirmation: '')
    end

    it 'dose not add a user' do
      expect do
        post signup_path, params: { user: user_params }
      end.to change(User, :count).by(0)
    end
  end

  describe "#edit" do
  # 認可されたユーザーとして
  context "as an authorized user" do
    it "responds successfully" do
      sign_in_as user
      get edit_user_path(user)
      expect(response).to be_success
      expect(response).to have_http_status "200"
    end
  end

  # ログインしていないユーザーの場合
  context "as a guest" do
    # ログイン画面にリダイレクトすること
    it "redirects to the login page" do
      get edit_user_path(user)
      expect(response).to have_http_status "302"
      expect(response).to redirect_to login_path
    end
  end

  # アカウントが違うユーザーの場合
  context "as other user" do
    # ホーム画面にリダイレクトすること
    it "redirects to the login page" do
      sign_in_as other_user
      get edit_user_path(user)
      expect(response).to redirect_to root_path
    end
  end
end

describe "#update" do
  # 認可されたユーザーとして
  context "as an authorized user" do
    # ユーザーを更新できること
    it "updates a user" do
      user_params = FactoryBot.attributes_for(:user, name: "NewName")
      sign_in_as user
      patch user_path(user), params: { id: user.id, user: user_params }
      expect(user.reload.name).to eq "NewName"
    end
  end

  # ログインしていないユーザーの場合
  context "as a guest" do
    # ログイン画面にリダイレクトすること
    it "redirects to the login page" do
      user_params = FactoryBot.attributes_for(:user, name: "NewName")
      patch user_path(user), params: { id: user.id, user: user_params }
      expect(response).to have_http_status "302"
      expect(response).to redirect_to login_path
    end
  end

  # アカウントが違うユーザーの場合
  context "as other user" do
    # ユーザーを更新できないこと
    it "does not update the user" do
      user_params = FactoryBot.attributes_for(:user, name: "NewName")
      sign_in_as other_user
      patch user_path(user), params: { id: user.id, user: user_params }
      expect(user.reload.name).to eq other_user.name
    end

    # ホーム画面にリダイレクトすること
    it "redirects to the login page" do
      user_params = FactoryBot.attributes_for(:user, name: "NewName")
      sign_in_as other_user
      patch user_path(user), params: { id: user.id, user: user_params }
      expect(response).to redirect_to root_path
    end
  end
end

  describe "#destroy" do
    context "as an autorized user" do
      it "deletes a user" do
        sign_in_as admin_user
        expect {
          delete user_path(admin_user), params: { id: admin_user.id }
      }.to change(User, :count).by(-1)
      end
    end

    context "as an unauthorized user" do
      before { sign_in_as other_user }
      it "redirects to the dashbord" do
        delete user_path(user), params: { id: user.id }
        expect(response).to redirect_to root_path
      end

      it "returns a 302 response" do
        delete user_path(user), params: { id: user.id }
        expect(response).to have_http_status "302"
      end
    end

    it "redirects to the sign-in page" do
      delete user_path(user), params: { id: user.id }
      expect(response).to redirect_to login_path
    end
  end

  describe "#create" do
  include ActiveJob::TestHelper

    it "is invalid with invalid sign up information" do
      perform_enqueued_jobs do
        expect {
          post users_path, params: { user: { name: "",
                                            email: "user@invalid",
                                            password: "foo",
                                            password_confirmation: "bar" }}
      }.to_not change(User, :count)
      end
    end

    it "is invalid with valid sign up information" do
      perform_enqueued_jobs do
        expect {
          post users_path, params: { user: { name: "ExampleUser",
                                             email: "user@example.com",
                                             password: "password",
                                             password_confirmation: "password" } }
      }.to change(User, :count).by(1)

      expect(response).to redirect_to root_path
      user = assigns(:user)

      sign_in_as(user)
      expect(session[:user_id]).to be_falsy

      get edit_account_activation_path("invalid token", email: user.email)
      expect(session[:user_id]).to be_falsy

      get edit_account_activation_path(user.activation_token, email: "wrong")
      expect(session[:user_id]).to be_falsy

      get edit_account_activation_path(user.activation_token, email: user.email)
      expect(session[:user_id]).to eq user.id
      expect(user.name).to eq "ExampleUser"
      expect(user.email).to eq "user@example.com"
      expect(user.password).to eq "password"
      end
    end
  end
end
end