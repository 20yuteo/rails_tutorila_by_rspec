FactoryBot.define do
    factory :user do
      name { 'Example User' }
      sequence(:email) { |n| "user_#{n}@example.com" }
      password { 'password' }
      password_confirmation { 'password' }
      admin { false }
    end

    # factory :admin_user do
    #   name { 'Admin User' }
    #   sequence(:email) { "admin_user@example.com" }
    #   password { 'password' }
    #   password_confirmation { 'password' }
    #   admin { true }
    # end
  end