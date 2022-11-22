class BooksController < ApplicationController
  before_action :is_matching_login_user, only: [:edit, :update, :destroy]

  def index
    @user=current_user
    @book=Book.new
    @books=Book.all
  end

  def show
    @user=current_user
    @book=Book.find(params[:id])
  end

  def create
    # 1,2. データを受け取り新規登録するためのインスタンス作成
    @book=Book.new(book_params)

    @book.user_id=current_user.id
    # データが入力されているかのif文
    if @book.save
      flash[:notice]="Book was successfully created"
      redirect_to book_path(@book.id)
    else
      # render index に行く前にindexにあるbooks変数に値をセットする
      @books=Book.all
      @user=current_user
      render :index
    end
  end

  def edit
    @user=current_user
    @book=Book.find(params[:id])
  end

  def update
    @book=Book.find(params[:id])
    # データが入力され、アップデートされているかどうか
    # データ入力されているとき
    if @book.update(book_params)
      flash[:notice]="Book was successfully update"
      redirect_to book_path(@book.id)
    # データ入力されてないとき
    else
      render :edit
    end
  end

  def destroy
    book=Book.find(params[:id])
    book.destroy
    flash[:notie]="Book was successfully destroyed"
    redirect_to books_path
  end

  # ストロングパラメータ
  private

  def is_matching_login_user
    book=Book.find(params[:id])
    user_id=book.user_id
    login_user_id=current_user.id
    if(user_id != login_user_id)
      redirect_to books_path
    end
  end

  def book_params
    params.require(:book).permit(:title, :body)
  end

end
