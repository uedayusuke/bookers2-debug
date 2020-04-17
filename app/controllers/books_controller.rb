class BooksController < ApplicationController
  before_action :authenticate_user!

  def new
    @book = Book.new
  end

  def show
  	@book = Book.find(params[:id])
    @user = User.find(current_user.id)
  end

  def index
  	@books = Book.all #一覧表示するためにBookモデルの情報を全てくださいのall
    @book = Book.new
    @user = User.find(current_user.id)
  end

  def create
  	@book = Book.new(book_params) #Bookモデルのテーブルを使用しているのでbookコントローラで保存する。
    @book.user_id = current_user.id
    @user = User.find(current_user.id)
    if @book.save
      flash[:notice] = "You have creatad book successfully."
      redirect_to book_path(@book.id)
    else
      @books = Book.all
      flash.now[:alert] = "error"
      render :index
    end
  end

  def edit
    @book = Book.new
  	@book = Book.find(params[:id])
    if @book.user != current_user
      redirect_to books_path
    end
  end



  def update
  	@book = Book.find(params[:id])
  	if @book.update(book_params)
  		flash[:notice] = "successfully updated book!"
      redirect_to book_path(@book)
  	else #if文でエラー発生時と正常時のリンク先を枝分かれにしている。
      flash.now[:alert] = "error"
      render action: :edit
  	end
  end

  def destroy
  	@book = Book.find(params[:id])
  	@book.destroy
  	redirect_to books_path, notice: "successfully delete book!"
  end

  private

  def book_params
  	params.require(:book).permit(:title, :body, :user_id)
  end

end
