class RelationshipsController < ApplicationController
  # フォローするとき
  def create
    current_user.follow(params[:user_id]) # followはUserモデルでフォローしたときの処理として定義
    #フォローをしたタイミングで通知レコードを作成する
    @user = User.find(params[:user_id])
    #通知の作成
    @user.create_notification_follow!(current_user) #create_notification_follow!はモデルで定義
    redirect_to request.referer
  end

  # フォロー外すとき
  def destroy
    current_user.unfollow(params[:user_id]) # unfollowはUserモデルでフォローを外したときの処理として定義
    redirect_to request.referer
  end

  # フォロー一覧
  def followings
    # user = User.find(params[:user_id])
    @user = User.find(params[:user_id])
    @users = @user.followings
  end

  # フォロワー一覧
  def followers
    @user = User.find(params[:user_id])
    @users = @user.followers
  end
end
