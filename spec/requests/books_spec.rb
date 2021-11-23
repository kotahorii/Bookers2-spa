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
  let!(:book) {create(:book)}
  let(:expected_response_object) do
    {
      'id' => "#{book.id}".to_i,
      'title' => "#{book.title}",
      'body' => "#{book.body}",
      'user_id' => user.id,
      'comments' => [],
      'favorites' => [],
      'created_at' => "#{book.created_at.strftime('%Y-%m-%dT%H:%M:%S.%3NZ')}",
    }
  end

  def auth_headers
    post 'http://localhost:8000/api/v1/auth/sign_in', params: { email: user['email'], password: 'password' }
    { 'uid' => response.header['uid'],
      'client' => response.header['client'],'access-token' => response.header['access-token'] }
  end

  describe '本の取得' do
      it '全ての投稿を取得' do
        get 'http://localhost:8000/api/v1/books'
        json = JSON.parse(response.body)
        expect(json[0]).to match(expected_response_object)
      end
  end

  describe '本の投稿' do
    let(:expected_response_object) do
     book = Book.last
      {
        'id' => "#{book.id}".to_i,
        'title' => "#{book.title}",
        'body' => "#{book.body}",
        'user_id' => user.id,
        'comments' => [],
        'favorites' => [],
        'created_at' => "#{book.created_at.strftime('%Y-%m-%dT%H:%M:%S.%3NZ')}",
      }
    end
      it 'データが作成されているか' do
        post 'http://localhost:8000/api/v1/books',
        params: { title: 'title', body: 'body' },
        headers: auth_headers
        json = JSON.parse(response.body)
        expect(json).to match(expected_response_object)
      expect(Book.all.count).to eq 2
      expect(response.status).to eq(200)
      end
  end

  describe '本の編集' do
    let(:expected_response_object) do
      book = Book.last
       {
         'id' => "#{book.id}".to_i,
         'title' => "#{book.title}",
         'body' => "#{book.body}",
         'user_id' => user.id,
         'comments' => [],
         'favorites' => [],
         'created_at' => "#{book.created_at.strftime('%Y-%m-%dT%H:%M:%S.%3NZ')}",
       }
     end
      it 'データが編集されているか' do
      book = create(:book)
       put "http://localhost:8000/api/v1/books/#{book.id}",
           params: { title: 'new', body: 'new' },
            headers: auth_headers
      json = JSON.parse(response.body)
      expect(json).to match(expected_response_object)
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

