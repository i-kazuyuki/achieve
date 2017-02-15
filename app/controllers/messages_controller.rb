class MessagesController < ApplicationController
  # どの会話なのかの処理を各アクションではなく共通の処理として定義
  before_action do
    @conversation = Conversation.find(params[:conversation_id])
  end


  def index
    # 会話にひもづくメッセージを取得
    @messages = @conversation.messages
    # メッセージの数が10よりも大きければ、10より大きいというフラグを有効にしてメッセージを最新の10に絞ることをする
    if @messages.length > 10
      @over_ten = true
      @messages = @messages[-10..-1]
    end
    # そうでなければ10より大きいというフラグを無効にして、会話にひもづくメッセージをすべて取得する
    if params[:m]
      @over_ten = false
      @messages = @conversation.messages
    end
    # もしメッセージが最新（最後）のメッセージで、かつユーザIDが自分（ログインユーザ）でなければ、その最新（最後）のメッセージを既読にする
    if @messages.last
      if @messages.last.user_id != current_user.id
       @messages.last.read = true
      end
    end
    # 新規投稿のメッセージ用の変数を作成
    @message = @conversation.messages.build
  end

  def create
    # HTTPリクエスト上のパラメータを利用して会話にひもづくメッセージを生成
    @message = @conversation.messages.build(message_params)
    # 保存ができれば、会話にひもづくメッセージ一覧の画面に遷移する
    if @message.save
      redirect_to conversation_messages_path(@conversation)
    end
  end

  private
    def message_params
      params.require(:message).permit(:body, :user_id)
    end
end
