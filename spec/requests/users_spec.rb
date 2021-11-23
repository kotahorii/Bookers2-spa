require 'rails_helper'

FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "test_#{n}" }
    sequence(:email) { |n| "test+#{n}@example.com" }
    password { 'password' }
  end
end

RSpec.describe 'Users', type: :request do
  let!(:user) { create(:user) }

  def auth_headers
    post 'http://localhost:8000/api/v1/auth/sign_in', params: { email: user['email'], password: 'password' }
    { 'uid' => response.header['uid'],
      'client' => response.header['client'], 'access-token' => response.header['access-token'] }
  end

  describe '認証のテスト' do
    context '未ログインの場合' do
      example 'HTTPステータスが401であること' do
        get 'http://localhost:8000/api/v1/auth/sessions'
        expect(response.status).to eq(401)
      end
    end
    context 'ログインずみの場合' do
      before do
        get 'http://localhost:8000/api/v1/auth/sessions', headers: auth_headers
      end
      example 'HTTPステータスが200であること' do
        expect(response.status).to eq(200)
      end
      example 'レスポンスが正しいこと' do
        expect(JSON.parse(response.body)['id']).to eq(user['id'])
      end
    end
  end

  describe '認証のテスト' do
    it 'ユーザーの編集' do
      put "http://localhost:8000/api/v1/users/#{user.id}",
      params: { name: 'new' },
       headers: auth_headers
 json = JSON.parse(response.body)
 expect(json['name']).to eq('new')
    end
    end
end

