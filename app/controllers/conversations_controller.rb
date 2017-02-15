class ConversationsController < ApplicationController
  # ログインしている際にのみ可能にするために制御
  before_action :authenticate_user!

  def index
    # すべてのユーザと会話一覧を取得
    @users = User.all
    @conversations = Conversation.all
  end

  def create
    # 該当のユーザ間での会話が過去に存在しているかを確認する式
    if Conversation.between(params[:sender_id], params[:recipient_id]).present?
      # 会話が過去に存在している場合は、その会話を取得
      @conversation = Conversation.between(params[:sender_id], params[:recipient_id]).first
    else
      # 過去に一件も存在しなかった場合は強制的にメッセージを生成
      @conversation = Conversation.create!(conversation_params)
    end
    # いずれの状態であってもその後その会話に紐づくメッセージの一覧画面へ遷移させる式
    redirect_to conversation_messages_path(@conversation)
  end

  private
    def conversation_params
      params.permit(:sender_id, :recipient_id)
    end
end
