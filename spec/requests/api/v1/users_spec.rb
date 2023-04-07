require 'rails_helper'

RSpec.describe "Api::V1::Users", type: :request do
  before do
    users = create_list :user, 3
    @user1, @user2, @user3 = *users
  end

  describe "#create" do
    context 'initialization' do
      it 'User has 3 row' do
        expect(User.count).to eq 3
      end
    end

    context 'successful' do
      before do
        user = build :user
        post api_v1_users_path, params: { user: user.attributes }
      end
      it "returns http success" do
        expect(response).to have_http_status(:success)
      end
      it "returns User count equal 4" do
        expect(User.count).to eq 4
      end
    end

    context 'failed' do
      context 'duplicate name' do
        before do
          create(:user, name: 'Mirzalazuardi')
        end
        it 'returns unprocessable_entity' do
          post api_v1_users_path, params: { user: { name: 'Mirzalazuardi' } }
          expect(response).to have_http_status(:unprocessable_entity)
        end
        it "returns User count equal 4" do
          expect(User.count).to eq 4
        end
      end
      context 'missing required field' do
        before do
          post api_v1_users_path, params: { user: {} }
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

  describe '#follow' do
      context 'passed' do
        before do
          post api_v1_follow_path(follower: { follower_id: @user2.id }),
            headers: { key: @user1.key, secret: @user1.secret }
        end
        it 'status ok' do
          expect(response).to have_http_status(:ok)
        end 
        it 'user1 has a follower' do
          expect(@user1.followers.count).to eq 1
        end
        it 'user1 have 2 followers' do
          post api_v1_follow_path(follower: { follower_id: @user3.id }),
            headers: { key: @user1.key, secret: @user1.secret }

          expect(@user1.followers.count).to eq 2
        end
        it 'user2 has a following' do
          expect(@user2.following.count).to eq 1
        end
        it 'user2 have 2 followings' do
          post api_v1_follow_path(follower: { follower_id: @user2.id }),
            headers: { key: @user3.key, secret: @user3.secret }
          expect(@user2.following.count).to eq 2
        end
      end
      context 'failed' do
        it 'status unauthorized' do
          post api_v1_follow_path(follower: { follower_id: @user2.id}),
            headers: {key: 'wrongkey', secret: 'wrongsecret'}
          expect(response).to have_http_status(:unauthorized)
        end 
      end
  end

  describe '#unfollow' do
      context 'passed' do
        before do
          create :follower, user: @user1, follower_id: @user2.id
          create :follower, user: @user3, follower_id: @user2.id
          post api_v1_unfollow_path(
            follower: { user_id: @user1.id }),
            headers: { key: @user2.key, secret: @user2.secret }
        end
        it 'status ok' do
          expect(response).to have_http_status(:ok)
        end 
        it 'user1 has no follower' do
          expect(@user1.followers.count).to eq 0
        end
        it 'user3 has a follower' do
          expect(@user3.followers.count).to eq 1
        end
        it 'user3 has no follower after unfollow by user2' do
          post api_v1_unfollow_path(
            follower: { user_id: @user3.id }),
            headers: { key: @user2.key, secret: @user2.secret }
          expect(@user3.followers.count).to eq 0
        end
        it 'user2 has a following' do
          expect(@user2.following.count).to eq 1
        end
        it 'user2 has no following after unfollow user3' do
          post api_v1_unfollow_path(
            follower: { user_id: @user3.id }),
            headers: { key: @user2.key, secret: @user2.secret }
          expect(@user2.following.count).to eq 0
        end
      end
      context 'failed' do
        it 'status unauthorized' do
          post api_v1_unfollow_path(follower: { user_id: @user1.id}),
            headers: {key: 'wrongkey', secret: 'wrongsecret'}
          expect(response).to have_http_status(:unauthorized)
        end 
        it 'status not found' do
          post api_v1_unfollow_path(follower: { user_id: @user2.id}),
            headers: { key: @user1.key, secret: @user1.secret }
          expect(response).to have_http_status(:not_found)
        end 
      end
  end
end
