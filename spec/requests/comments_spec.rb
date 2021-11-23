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
  let(:json) {JSON.parse(response.body)}
  let!(:user) { create(:user) }
  let!(:book) {create(:book)}
  let!(:comment) { create(:comment) }
  let(:expected_response_object) do
    {
      'id' => "#{book.id}".to_i,
      'comment' => "#{comment.comment}",
      'user_id' => user.id,
      'book_id' => book.id,
      'created_at' => "#{comment.created_at.strftime('%Y-%m-%dT%H:%M:%S.%3NZ')}",
      'updated_at' => "#{comment.updated_at.strftime('%Y-%m-%dT%H:%M:%S.%3NZ')}"
    }
  end

  def auth_headers
    post 'http://localhost:8000/api/v1/auth/sign_in', params: { email: user['email'], password: 'password' }
    { 'uid' => response.header['uid'],
      'client' => response.header['client'],'access-token' => response.header['access-token'] }
  end

  describe 'コメントの取得' do
    it '全ての投稿を取得' do
      get 'http://localhost:8000/api/v1/comments'
      expect(json[0]).to match(expected_response_object)
    end
  end

  describe 'コメントの投稿' do
    before do
      post 'http://localhost:8000/api/v1/comments',
      params: { comment: 'comment', book_id: book['id'] },
      headers: auth_headers
    end
    let(:expected_response_object) do
     comment = Comment.last
      {
        'id' => "#{comment.id}".to_i,
        'comment' => "#{comment.comment}",
        'user_id' => user.id,
        'book_id' => book.id,
        'created_at' => "#{comment.created_at.strftime('%Y-%m-%dT%H:%M:%S.%3NZ')}",
        'updated_at' => "#{comment.updated_at.strftime('%Y-%m-%dT%H:%M:%S.%3NZ')}"
      }
    end
    it 'データが作成されているか' do
      expect(json).to match(expected_response_object)
      expect(Comment.all.count).to eq 2
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
