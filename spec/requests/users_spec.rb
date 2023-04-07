require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "#create" do
    context 'initialization' do
      it 'User has 0 row' do
        expect(User.count).to eq 0
      end
    end

    context 'successful' do
      before do
        user = build :user
        post users_path, params: user.attributes
      end
      it "returns http success" do
        expect(response).to have_http_status(:success)
      end
      it "returns User count equal 1" do
        expect(User.count).to eq 1
      end
    end

    context 'failed' do
      context 'duplicate name' do
        before do
          create(:user, name: 'Mirzalazuardi')
        end
        it 'returns unprocessable_entity' do
          post users_path, params: {name: 'Mirzalazuardi'}
          expect(response).to have_http_status(:unprocessable_entity)
        end
        it "returns User count equal 1" do
          expect(User.count).to eq 1
        end
      end
      context 'missing required field' do
        before do
          post users_path, params: {}
        end
        it 'returns unprocessable_entity' do
          expect(response).to have_http_status(:bad_request)
        end
        it 'returns error message' do
          expect(response_json['error']).to eq 'Required field missing: name'
        end
      end
    end
  end
end
