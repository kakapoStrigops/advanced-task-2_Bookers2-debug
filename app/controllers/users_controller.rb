class UsersController < ApplicationController
  before_action :ensure_correct_user, only: [:edit, :update]

  def show
    @user = User.find(params[:id])
    @books = @user.books
    @book = Book.new
    @today_book = @books.created_today
    @yesterday_book = @books.created_yesterday
    @this_week_book = @books.created_this_week
    @last_week_book = @books.created_last_week



    # @book_count_today =  @user.books.where(created_at: Date.today.all_day).count
    # @book_count_yesterday = @user.books.where(created_at: 1.day.ago.all_day).count
    # if @book_count_yesterday != 0
    #   @the_day_before = @book_count_today / @book_count_yesterday
    # else
    #   @the_day_before = "-"
    # end
    # @book_count_thisweek = @user.books.where(created_at:Date.today.all_week).count
    # @book_count_lastweek = @user.books.where(created_at: 1.week.ago.all_week).count
    # if @book_count_lastweek != 0
    #   @week_over_week = @book_count_thisweek / @book_count_lastweek
    # else
    #   @week_over_week = "-"
    # end
  end

  def index
    @users = User.all
    @book = Book.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "You have updated user successfully."
    else
      render "edit"
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end
end
