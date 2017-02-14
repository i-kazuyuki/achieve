class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # BlogモデルのAssociationを設定
  has_many :blogs, dependent: :destroy

  # CommentモデルのAssociationを設定
  has_many :comments, dependent: :destroy

  # follow機能(Userが複数のRelationShipを持つことを定義)
  # RelationshipモデルのAssociationを設定
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :reverse_relationships, foreign_key: "followed_id", class_name: "Relationship", dependent: :destroy
  # UserモデルがRelationshipモデルを介して複数のUserを所持することを定義
  # 「自分」と「自分”が”フォローしている人」の1対多の関係性
  has_many :followed_users, through: :relationships, source: :followed
  # 「自分」と「自分”を”フォローしている人」の1対多の関係性です。
  has_many :followers, through: :reverse_relationships, source: :follower
  # follow機能に必要なメソッドの定義
  # 指定のユーザをフォローする
  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end
  # フォローしているかどうかを確認する
  def following?(other_user)
    relationships.find_by(followed_id: other_user.id)
  end
  #指定のユーザのフォローを解除する
  def unfollow!(other_user)
    relationships.find_by(followed_id: other_user.id).destroy
  end

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable, :omniauthable
  # ↓はdeviseの設定配下に追記
  mount_uploader :avatar, AvatarUploader

  # Facebookの設定
  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.find_by(email: auth.info.email)

    unless user
      user = User.new(
        name:     auth.extra.raw_info.name,
        provider: auth.provider,
        uid:      auth.uid,
        email:    auth.info.email ||= "#{auth.uid}-#{auth.provider}@example.com",
        image_url:   auth.info.image,
        password: Devise.friendly_token[0, 20]
      )
        user.skip_confirmation!
        user.save(validate: false)
      end
      user
    end

    # Twitterの設定
    def self.find_for_twitter_oauth(auth, signed_in_resource = nil)
      user = User.find_by(provider: auth.provider, uid: auth.uid)

      unless user
        user = User.new(
            name:     auth.info.nickname,
            image_url: auth.info.image,
            provider: auth.provider,
            uid:      auth.uid,
            email:    auth.info.email ||= "#{auth.uid}-#{auth.provider}@example.com",
            password: Devise.friendly_token[0, 20]
        )
        user.skip_confirmation!
        user.save
      end
      user
    end

    # ランダムなuidを作成するcreate_unique_stringメソッド
    def self.create_unique_string
      SecureRandom.uuid
    end

    # omniauthでサインアップしたアカウントのユーザ情報の変更が出来るようにする
    def update_with_password(params, *options)
      if provider.blank?
        super
      else
        params.delete :current_password
        update_without_password(params, *options)
      end
    end
end
