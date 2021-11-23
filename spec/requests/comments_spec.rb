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

  factory :comment do
    comment { 'comment' }
    user_id { 1 }
    book_id { 1 }
  end
end

RSpec.describe 'Comment', type: :request do
  let!(:user) { create(:user) }

  def auth_headers
    post 'http://localhost:8000/api/v1/auth/sign_in', params: { email: user['email'], password: 'password' }
    { 'uid' => response.header['uid'],
      'client' => response.header['client'],'access-token' => response.header['access-token'] }
  end

  describe 'コメントの取得' do
    it '全てのコメントを取得' do
      FactoryBot.create(:book)
      FactoryBot.create_list(:comment, 10)
      get 'http://localhost:8000/api/v1/comments'
      json = JSON.parse(response.body)
      expect(json.length).to eq(10)
    end
  end

  describe 'コメントの投稿' do
    it 'データが作成されているか' do
      book = create(:book)
      expect { post 'http://localhost:8000/api/v1/comments',
      params: { comment: 'comment', book_id: book['id'] },
      headers: auth_headers}.to change(Comment, :count).by(+1)
    end
  end

  describe 'コメントの削除' do
    it 'データが削除されているか' do
      book = create(:book)
      comment = create(:comment, book_id: book.id)
      expect { delete "http://localhost:8000/api/v1/books/#{comment.id}",
      headers: auth_headers}.to change(Comment, :count).by(-1)
    end
  end
end
