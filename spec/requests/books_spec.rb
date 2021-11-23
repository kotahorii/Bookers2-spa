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
end

RSpec.describe 'Books', type: :request do
  let!(:user) { create(:user) }

  def auth_headers
    post 'http://localhost:8000/api/v1/auth/sign_in', params: { email: user['email'], password: 'password' }
    { 'uid' => response.header['uid'],
      'client' => response.header['client'],'access-token' => response.header['access-token'] }
  end

  describe '本の取得' do
      it '全ての投稿を取得' do
        FactoryBot.create_list(:book, 10)
        get 'http://localhost:8000/api/v1/books'
        json = JSON.parse(response.body)
        expect(json.length).to eq(10)
    end
  end

  describe '本の投稿' do
      it 'データが作成されているか' do
        expect { post 'http://localhost:8000/api/v1/books',
        params: { title: 'title', body: 'body' },
        headers: auth_headers}.to change(Book, :count).by(+1)
      end
  end

  describe '本の編集' do
      it 'データが編集されているか' do
      book = create(:book, title: 'old', body: 'old')
       put "http://localhost:8000/api/v1/books/#{book.id}",
           params: { title: 'new', body: 'new' },
            headers: auth_headers
      json = JSON.parse(response.body)
      expect(json['title']).to eq('new')
      expect(response.status).to eq(200)
    end
  end

  describe '本の削除' do
      it 'データが削除されているか' do
      book = create(:book, title: 'old', body: 'old')
      expect { delete "http://localhost:8000/api/v1/books/#{book.id}",
   headers: auth_headers}.to change(Book, :count).by(-1)
    end
  end
end

