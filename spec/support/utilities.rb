def sign_in_as(user)
    post login_path, params: { session: { email: user.email,
                                        password: user.password } }
end

def log_in_as(user)
    visit root_path
    # binding.pry
    click_link 'Log in'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Log in'
end