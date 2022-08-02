class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books, dependent: :destroy
  has_one_attached :profile_image
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy

  # フォローする関係(フォロワーになります！という人、フォロー行為の能動者、フォロワー)
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  # フォローをした関係（フォロー対象相手、フォロー行為の受動者、フォロワーがフォローしましたよの相手）
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy

  #一覧画面で使う
  # フォローイング（フォロー対象相手）
  has_many :followings, through: :relationships, source: :followed
  # フォロワー（フォローしてくれている人）
  has_many :followers, through: :reverse_of_relationships, source: :follower

  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction,  length: { maximum: 50 }


  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end

  # フォローしたときの処理
  def follow(other_user_id)
    relationships.create(followed_id: other_user_id)
  end

  # フォローを外す時の処理
  def unfollow(other_user_id)
    relationships.find_by(followed_id: other_user_id).destroy
  end

  # 相手をフォローしているか判定
  def following?(other_user)
    followings.include?(other_user)
  end

end
