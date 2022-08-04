class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books, dependent: :destroy
  has_one_attached :profile_image
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy

  # フォローする関係(フォロワーになります！という人、フォロー行為の能動者、フォロワー)のUserから見て、フォロー対象者のUserを（中間テーブルを介して）集める。
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  # フォローをした相手（フォロー対象相手、フォロー行為の受動者、フォロワーがフォローしましたよの相手）のUserから見て、フォローしてくる側のUserを（中間テーブルを介して）集める。
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy

  #一覧画面で使う
  # 中間テーブルを介して、「followed」モデルのUser（フォローされた側）を集めることを「following」と定義。
  has_many :followings, through: :relationships, source: :followed
  # 中間テーブルを介して、「follower」モデルのUser（フォローする側）を集めることを「followers」と定義。
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

  def self.search_for(content, method)
    if method == "perfect"
      User.where("name LIKE?", "#{content}")
    elsif method == "forward"
      User.where("name LIKE?", "#{content}%")
    elsif method == "backward"
      User.where("name LIKE?", "%#{content}")
    elsif method == "partial"
      User.where("name LIKE?", "%#{content}%")
    else
      User.all
    end
  end

end
