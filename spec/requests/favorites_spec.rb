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

  def auth_headers
    post 'http://localhost:8000/api/v1/auth/sign_in', params: { email: user['email'], password: 'password' }
    { 'uid' => response.header['uid'],
      'client' => response.header['client'],'access-token' => response.header['access-token'] }
  end

  describe 'いいねの取得' do
    before do
      book = FactoryBot.create(:book)
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
    it 'データが作成されているか' do
      book = create(:book)
      expect { post 'http://localhost:8000/api/v1/favorites',
      params: { book_id: book['id'] },
      headers: auth_headers}.to change(Favorite, :count).by(+1)
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
