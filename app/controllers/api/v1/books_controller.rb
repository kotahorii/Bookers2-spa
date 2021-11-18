class Api::V1::BooksController < ApplicationController
  before_action :set_book, except: %i[index create]

  def index
    books = Book.all
    render json: { status: 200, data: books }
  end

  def create
    book = Book.new(book_params)
    book.user_id = current_api_v1_user.id
    if book.save
      render json: { status: 200, data: book }
    else
      render json: { status: 500, data: '投稿に失敗しました' }
    end
  end

  def update
    @book.title = book_params[:title]
    @book.body = book_params[:body]
    @book.user_id = current_api_v1_user.id

    if @book.save
      render json: { status: 200, data: @book }
    else
      render json: { status: 500, data: '更新に失敗しました' }
    end
  end

  def destroy
    if @book.destroy
      render json: { status: 200, data: '投稿を削除しました' }
    else
      render josn: { status: 500, data: '削除に失敗しました' }
    end
  end

  private

  def set_book
    @book = Book.find(params[:id])
  end

  def book_params
    params.permit(:title, :body)
  end
end
