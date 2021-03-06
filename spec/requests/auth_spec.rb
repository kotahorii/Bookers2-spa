require 'rails_helper'

FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "test_#{n}" }
    sequence(:email) { |n| "test+#{n}@it.com" }
    password { 'password' }
  end
end


RSpec.describe 'Auth', type: :request do

  let!(:user) {create(:user)}

  describe 'ユーザーログインのテスト' do
    context '正常' do
      before do
        post 'http://localhost:8000/api/v1/auth/sign_in', params: {email:user['email'], password: 'password'}
      end

      it 'HTTPステータスが200であること' do
        expect(response.status).to eq(200)
      end

      it 'レスポンスが正しいこと' do
        json = JSON.parse(response.body)
        expect(json['data']['email']).to eq(user['email'])
      end
    end

    context '異常' do
      before do
        post 'http://localhost:8000/api/v1/auth/sign_in', params: { email:user['email'], password: 'passwordxxx'}
      end

      it 'HTTPステータスが401であること' do
        expect(response.status).to eq(401)
      end

      it 'レスポンスが正しいこと' do
        json = JSON.parse(response.body)
        expect(json['success']).to eq(false)
      end
    end
  end

  describe 'ユーザー登録のテスト' do
    context '正常' do
      let(:params) {{name: 'test', email:'test@it.com', password:'password'}}
      before do
        post 'http://localhost:8000/api/v1/auth', params: params
      end

      it 'HTTPステータスが200であること' do
        expect(response.status).to eq(200)
      end

      it 'レスポンスが正しいこと' do
        expect(JSON.parse(response.body)['status']).to eq("success")
      end
    end
  end
end

