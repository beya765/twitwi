class Micropost < ApplicationRecord
  belongs_to :user
  default_scope -> { order(created_at: :desc) } # DBのsqlに引数指定
  # Micropostモデルに画像を追加する(引数に属性名のシンボルと生成されたアップローダーのクラス名)
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validate :picture_size # 独自バリデーション

  private
    # アップロードされた画像のサイズをバリデーションする
    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "ファイルサイズが5MBを超えています")
      end
    end
end
