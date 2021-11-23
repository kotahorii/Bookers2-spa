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
    it 'データが作成されているか' do
      book = create(:book)
      expect { post 'http://localhost:8000/api/v1/rates',
      params: { rate:2, book_id: book['id'] },
      headers: auth_headers}.to change(Rate, :count).by(+1)
    end
  end

  describe '評価の削除' do
    it 'データが削除されているか' do
      book = create(:book)
      post "http://localhost:8000/api/v1/rates",
      params: { rate:2, book_id: book.id },
      headers: auth_headers
      expect { delete "http://localhost:8000/api/v1/books/1",
      headers: auth_headers}.to change(Rate, :count).by(-1)
    end
  end
end