class BookSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :user_id, :comments, :favorites
end
