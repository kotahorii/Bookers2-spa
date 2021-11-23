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

  factory :favorite do
    favorite { 'favorite' }
    user_id { 1 }
    book_id { 1 }
  end
end

RSpec.describe 'favorite', type: :request do
  let!(:user) { create(:user) }
  let(:json) {JSON.parse(response.body)}
  

  def auth_headers
    post 'http://localhost:8000/api/v1/auth/sign_in', params: { email: user['email'], password: 'password' }
    { 'uid' => response.header['uid'],
      'client' => response.header['client'],'access-token' => response.header['access-token'] }
  end

  describe 'いいねの取得' do
    let!(:book) {create(:book)}
    before do
      post 'http://localhost:8000/api/v1/favorites',
      params: { book_id: book['id'] },
      headers: auth_headers
    end
    it '全てのいいねを取得' do
      get 'http://localhost:8000/api/v1/favorites',
      headers: auth_headers
      json = JSON.parse(response.body)
      expect(json.length).to eq(1)
    end
  end

  describe 'いいねの投稿' do
    let!(:book) {create(:book)}
      before do
        post 'http://localhost:8000/api/v1/favorites',
        params: { book_id: book.id },
        headers: auth_headers
      end
    let!(:user) { create(:user)}
    let(:expected_response_object) do
      favorite = Favorite.last
      {
        'id' => "#{favorite.id}".to_i,
        'book_id' => "#{book.id}".to_i,
        'user_id' => user.id,
        'created_at' => "#{favorite.created_at.strftime('%Y-%m-%dT%H:%M:%S.%3NZ')}",
        'updated_at' => "#{favorite.updated_at.strftime('%Y-%m-%dT%H:%M:%S.%3NZ')}"
      }
    end
    it 'データが作成されているか' do
      expect(Favorite.all.count).to eq 1
      expect(json).to match(expected_response_object)
      expect(response).to have_http_status 200
    end
  end

  describe 'いいねの削除' do
    it 'データが削除されているか' do
      book = create(:book)
      post "http://localhost:8000/api/v1/favorites",
      params: { book_id: book.id },
      headers: auth_headers
      expect { delete "http://localhost:8000/api/v1/books/1",
      headers: auth_headers}.to change(Favorite, :count).by(-1)
    end
  end
end
