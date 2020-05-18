require 'rails_helper'

RSpec.describe "StaticPages", type: :request do
    context 'GET #home' do
        before { get root_path }
        it 'responds successfully' do
            expect(response).to have_http_status 200
        end
        it "has title 'Ruby on Rails Tutorial Sample App'" do
            expect(response.body).to include 'Ruby on Rails Tutorial Sample App'
            expect(response.body).to_not include '| Ruby on Rails Tutorial Sample App'
        end
    end

    context 'GET #help' do
        before { get static_pages_help_url }
        it 'responds successfully' do
            expect(response).to have_http_status 200
        end
        it "has title 'Home | Ruby on Rails Tutorial Sample App'" do
            expect(response.body).to include 'Help | Ruby on Rails Tutorial Sample App'
        end
    end

    context 'GET #about' do
        before { get static_pages_about_url }
        it 'responds succesfully' do
            expect(response).to have_http_status 200
        end
        it "has title 'Home | Ruby on Rails Tutorial Sample App'" do
            expect(response.body).to include 'About | Ruby on Rails Tutorial Sample App'
        end
    end
end
