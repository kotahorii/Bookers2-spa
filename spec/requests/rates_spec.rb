require 'rails_helper'

FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "test_#{n}" }
    sequence(:email) { |n| "test+#{n}@it.com" }
    password { 'password' }
  end

  factory :book do
    title { 'title' }
    body { 'body' }
    user_id { 1 }
  end

  factory :rate do
    rate { 'rate' }
    user_id { 1 }
    book_id { 1 }
  end
end

RSpec.describe 'rate', type: :request do
  let!(:user) { create(:user) }
  let!(:book) {create(:book)}
  let(:json) {JSON.parse(response.body)}

  def auth_headers
    post 'http://localhost:8000/api/v1/auth/sign_in', params: { rate:2, email: user['email'], password: 'password' }
    { 'uid' => response.header['uid'],
      'client' => response.header['client'],'access-token' => response.header['access-token'] }
  end

  describe '評価の取得' do
    before do
      book = FactoryBot.create(:book)
      post 'http://localhost:8000/api/v1/rates',
      params: { rate:2, book_id: book['id'] },
      headers: auth_headers
    end
    it '全ての評価を取得' do
      get 'http://localhost:8000/api/v1/rates',
      headers: auth_headers
      json = JSON.parse(response.body)
      expect(json.length).to eq(1)
    end
  end
  describe '評価の投稿' do
    before do
      post 'http://localhost:8000/api/v1/rates',
      params: { rate:2, book_id: book.id },
      headers: auth_headers
    end
    let(:expected_response_object) do
      rate = Rate.last
      {
        'id' => rate.id,
        'book_id' => "#{book.id}".to_i,
        'user_id' => user.id,
        'rate' => rate.rate,
        'created_at' => "#{rate.created_at.strftime('%Y-%m-%dT%H:%M:%S.%3NZ')}",
        'updated_at' => "#{rate.updated_at.strftime('%Y-%m-%dT%H:%M:%S.%3NZ')}"
      }
    end
    it 'データが作成されているか' do
      expect(Rate.all.count).to eq 1
      expect(json).to match(expected_response_object)
      expect(response).to have_http_status 200
    end
  end
  describe '評価の更新' do
    let(:expected_response_object) do
      rate = Rate.last
       {
         'id' => book.id,
         'rate' => rate.rate,
         'book_id' => book.id,
         'user_id' => user.id,
         'created_at' => "#{rate.created_at.strftime('%Y-%m-%dT%H:%M:%S.%3NZ')}",
         'updated_at' => "#{rate.updated_at.strftime('%Y-%m-%dT%H:%M:%S.%3NZ')}",
       }
     end
    before do
      post 'http://localhost:8000/api/v1/rates',
      params: { rate:2, book_id: book.id },
      headers: auth_headers
    end
    it 'データが更新されているか' do
      rate = Rate.last
      put "http://localhost:8000/api/v1/rates/#{rate.id}",
      params: { rate:3, book_id: book.id },
      headers: auth_headers
      expect(json).to match(expected_response_object)
      expect(response.status).to eq(200)
    end
  end
end