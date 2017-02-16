class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    # 自分の通知のみ取得、通知は新しい順に並び替える。
    @notifications = Notification.where(user_id: current_user.id).order(created_at: :desc)
  end
end
