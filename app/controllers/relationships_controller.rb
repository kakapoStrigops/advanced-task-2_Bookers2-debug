class RelationshipsController < ApplicationController

  def create
    current_user.follow(params[:user_id])
    redirect_to request.referer
  end

  def destroy
    current_user.unfollow(params[:user_id])
    redirect_to request.referer
  end

  def follows
    user = User.find(params[:user_id])
    @users = user.following_user
  end

  def followers
    user = User.find(params[:user_id])
    @users = user.follower_user
  end

end
