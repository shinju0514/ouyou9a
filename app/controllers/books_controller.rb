class BooksController < ApplicationController
  before_action :correct_user, only: [:edit, :update]

  def show
    @book_new=Book.new
    @book = Book.find(params[:id])
    @user = @book.user
    @book_comment=BookComment.new
    # 閲覧数を記述するメソッド、unique:[:ip_address]は同じipアドレスでは閲覧数が増えない仕組みになっている。
    # unique:[;ip_address]の記述を消すと、同じipアドレスで閲覧数が増えます。
    impressionist(@book, nil,unique: [:ip_address])
  end

  def index
    @book = Book.new
    @user=current_user
    @rank_books = Book.order(impressions_count: 'DESC') # ソート機能を追加
    @books_favo = Book.includes(:favorited_users).sort {|a,b| b.favorited_users.size <=> a.favorited_users.size}
    if params[:impressions_count]
      @books = Book.pv
    else
      @books = Book.all
    end
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      flash[:notice]="successfully"
      redirect_to book_path(@book)
    else
      @books=Book.all
      @user=current_user
      render 'index'
    end
  end

 def edit
     @book = Book.find(params[:id])
 end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book) , notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title, :body)
  end

  def correct_user
    @book = Book.find(params[:id])
    @user = @book.user
    redirect_to(books_path) unless @user == current_user
  end
end
