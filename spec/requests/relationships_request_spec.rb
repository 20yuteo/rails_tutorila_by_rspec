require 'rails_helper'

RSpec.describe "Relationships", type: :request do

    let(:other_user) { FactoryBot.create(:user, activated_at: Time.zone.now) }

    context 'relationship request' do
        it 'is required login when create' do
            post relationships_path
            expect(response).to redirect_to login_url
        end

        it 'is required login when destroy' do
            delete relationship_path(other_user)
            expect(response).to redirect_to login_url
        end
    end

end
