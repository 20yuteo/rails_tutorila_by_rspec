require 'rails_helper'
require 'shoulda-matchers'
# require './user.rb'

RSpec.describe User, type: :model do
  let(:user) { FactoryBot.create(:user, activated: true) }
  let(:other_user) { FactoryBot.create(:user, name: 'other user', activated: true, activated_at: Time.zone.now) }
  #facrory botが存在するかのテストです
  it 'has a valid factory bot' do
    expect(build(:user)).to be_valid
  end
  #ここからバリデーションのテストです
  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_length_of(:name).is_at_most(50) }
    it { is_expected.to validate_length_of(:email).is_at_most(255) }
    it do
      is_expected.to allow_values('first.last@foo.jp',
                                  'user@example.com',
                                  'USER@foo.COM',
                                  'A_US-ER@foo.bar.org',
                                  'alice+bob@baz.cn').for(:email)
    end
    it do
      is_expected.to_not allow_values('user@example,com',
                                      'user_at_foo.org',
                                      'user.name@example.',
                                      'foo@bar_baz.com',
                                      'foo@bar+baz.com').for(:email)
    end

    describe 'validate unqueness of email' do
      let!(:user) { create(:user, email: 'original@example.com') }
      it 'is invalid with a duplicate email' do
        user = build(:user, email: 'original@example.com')
        expect(user).to_not be_valid
      end
      it 'is case insensitive in email' do
        user = build(:user, email: 'ORIGINAL@EXAMPLE.COM')
        expect(user).to_not be_valid
      end
    end
  end

  describe 'before_save' do
    describe '#email_downcase' do
      let!(:user) { create(:user, email: 'ORIGINAL@EXAMPLE.COM') }
      it 'makes email to low case' do
        expect(user.reload.email).to eq 'original@example.com'
      end
    end
  end

  # 追加した部分のみ書いてます。
  describe 'validations' do
    describe 'validate presence of password' do
      it 'is invalid with a blank password' do
        user = build(:user, password: ' ' * 6)
        expect(user).to_not be_valid
      end
    end
    it { is_expected.to validate_length_of(:password).is_at_least(6) }
  end

  describe "authenticated? should return false for a user with nil digest" do
    # ダイジェストが存在しない場合のauthenticated?のテスト
    it "is invalid without remember_digest" do
      remember_token = User.new_token
      expect(user.authenticated?(:remember, remember_token)).to eq false
    end
  end

  describe "User's test with micropost" do
    it "is associated microposts should be destroyed" do
      micropost = create(:micropost, user_id: user.id)
      expect{user.destroy}.to change(Micropost, :count).by (-1)
    end
  end

  describe 'relationship test' do
    it 'is following behavire' do
      var = user.following?(other_user)
      expect(var).to be_in([false])
      user.follow(other_user)
      var = user.following?(other_user)
      expect(var).to be_in([true])
      var = other_user.followers.include?(user)
      expect(var).to be_in([true])
      user.unfollow(other_user)
      var = user.following?(other_user)
      expect(var).to be_in([false])
    end
  end
end