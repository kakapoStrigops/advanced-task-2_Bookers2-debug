class RelationshipsController < ApplicationController

  def create
    @user = User.find(params[:user_id])
    current_user.follow(@user.id)
    # redirect_to request.referer
    render 'replace_relationships'
  end

  def destroy
    @user = User.find(params[:user_id])
    current_user.unfollow(@user.id)
    # redirect_to request.referer
    render 'replace_relationships'
  end

  # フォロー一覧
  def followings
    @user = User.find(params[:user_id])
    @other_users = @user.followings
  end

  # フォロワー一覧
  def followers
    @user = User.find(params[:user_id])
    @other_users = @user.followers
  end

end
