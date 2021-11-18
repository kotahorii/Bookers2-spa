class BookSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :user_id, :created_at, :comments, :favorites
end
