require 'rails_helper'

RSpec.describe "Api::V1::Users", type: :request do
  before do
    users = create_list :user, 8
    @user1, @user2, @user3, @user4, @user5, @user6, @user7, @user8 = *users
  end

  describe "#create" do
    context 'initialization' do
      it 'User have 8 rows' do
        expect(User.count).to eq 8
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
      it "returns User count equal 9" do
        expect(User.count).to eq 9
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
        it "returns User count equal 9" do
          expect(User.count).to eq 9
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
          post api_v1_follow_path,
            params: { follower: { follower_id: @user2.id } },
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
        it 'user2 has a followings' do
          expect(@user2.followings.count).to eq 1
        end
        it 'user2 have 2 followings' do
          post api_v1_follow_path(follower: { follower_id: @user2.id }),
            headers: { key: @user3.key, secret: @user3.secret }
          expect(@user2.followings.count).to eq 2
        end
      end
      context 'failed' do
        it 'status unauthorized' do
          post api_v1_follow_path,
            params: { follower: { follower_id: @user2.id} },
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
          post api_v1_unfollow_path,
            params: { follower: { user_id: @user1.id } },
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
          expect(@user2.followings.count).to eq 1
        end
        it 'user2 has no following after unfollow user3' do
          post api_v1_unfollow_path(
            follower: { user_id: @user3.id }),
            headers: { key: @user2.key, secret: @user2.secret }
          expect(@user2.followings.count).to eq 0
        end
      end
      context 'failed' do
        it 'status unauthorized' do
          post api_v1_unfollow_path,
            params: { follower: { user_id: @user1.id} },
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

  describe '#sleep_records' do
    context 'passed' do
      before do
        post api_v1_sleep_records_path,
          headers: { key: @user1.key, secret: @user1.secret }
      end
      it 'status ok' do
        expect(response).to have_http_status(:ok)
      end 
      context 'sleep start' do
        it_behaves_like "new sleep cycle", 1
      end
      context 'sleep finish' do
        before do
          Timecop.freeze(Time.now + 1.hour)
          post api_v1_sleep_records_path,
            headers: { key: @user1.key, secret: @user1.secret }
        end
        it_behaves_like 'finish sleep cyle(wake)', 1, 3600

        context 'begin a new sleep cycle(row)' do
          before do
            Timecop.return
            post api_v1_sleep_records_path,
              headers: { key: @user1.key, secret: @user1.secret }
          end
          it_behaves_like "new sleep cycle", 2
        end
      end
    end
    context 'failed' do
      before do
        post api_v1_sleep_records_path,
          headers: { key: 'wrongkey', secret: 'wrongsecret' }
      end
      it 'status unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end 
    end
  end

  describe '#display_sleep_records' do
    context 'passed' do
      before do
        post api_v1_sleep_records_path,
          headers: { key: @user1.key, secret: @user1.secret } #sleep
        Timecop.freeze(Time.now + 1.hour)
        post api_v1_sleep_records_path,
          headers: { key: @user1.key, secret: @user1.secret } #wake
        get api_v1_display_sleep_records_path,
          headers: { key: @user1.key, secret: @user1.secret }
      end
      it 'status ok' do
        expect(response).to have_http_status(:ok)
      end
      it 'return "1 hour" on duration attribute' do
        expect(response_json['data'].last.dig('attributes', 'duration'))
          .to eq '1 hour'
      end
    end
    context 'failed' do
      before do
        get api_v1_display_sleep_records_path,
          headers: { key: 'wrongkey', secret: 'wrongsecret' }
      end
      it 'status unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe '#friends_sleep_records' do
    context 'passed' do
      before do
        #user who not follow each other to user1 (user_ids: 2, 4, 6) #not friend
        create :follower, follower_id: @user2.id, user_id: @user1.id
        create :follower, follower_id: @user4.id, user_id: @user1.id
        create :follower, follower_id: @user6.id, user_id: @user1.id

        #user who follow each other to user1 (user_ids: 3, 5, 7) #friend
        create :follower, follower_id: @user3.id, user_id: @user1.id
        create :follower, follower_id: @user5.id, user_id: @user1.id
        create :follower, follower_id: @user7.id, user_id: @user1.id
        create :follower, follower_id: @user1.id, user_id: @user3.id
        create :follower, follower_id: @user1.id, user_id: @user5.id
        create :follower, follower_id: @user1.id, user_id: @user7.id

        Timecop.freeze(14.days.ago.beginning_of_day)
        Sleep.clock(@user7.id)
        Timecop.freeze(1.hour)
        Sleep.clock(@user7.id) # exclude because out of date range
        Timecop.freeze(7.days)
        Sleep.clock(@user2.id) 
        Sleep.clock(@user4.id)
        Sleep.clock(@user3.id)
        Sleep.clock(@user5.id)

        Timecop.freeze(1.hour)
        Sleep.clock(@user2.id)
        Sleep.clock(@user4.id)
        Timecop.freeze(2.hour)
        Sleep.clock(@user3.id) # count in
        Timecop.freeze(5.hour)
        Sleep.clock(@user5.id) # count in
        Timecop.return

        get api_v1_friends_sleep_records_path,
          headers: { key: @user1.key, secret: @user1.secret }
      end
      it 'status ok' do
        expect(response).to have_http_status(:ok)
      end
      it 'have 2 rows' do
        expect(response_json['data'].count).to eq 2
      end
      it 'the first data duration_seconds are greater than equal the last one(desc ordered)' do
        expect(response_json.dig('data', 0, 'attributes', 'duration_seconds'))
          .to be >= response_json.dig('data', 1, 'attributes', 'duration_seconds')
      end
    end
    context 'failed' do
      before do
        get api_v1_friends_sleep_records_path,
          headers: { key: 'wrongkey', secret: 'wrongsecret' }
      end
      it 'status unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
