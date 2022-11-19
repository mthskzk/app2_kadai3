class BooksController < ApplicationController

  # form_withに渡すための空のモデルを用意
  def new
    @book=Book.new
  end

  def index
    @books=Book.all
  end

  def show
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
      render :index
    end
  end

  def edit
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

  def book_params
    params.require(:book).permit(:title, :body)
  end

end
