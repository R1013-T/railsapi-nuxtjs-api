class User < ApplicationRecord

  # bcrypt
  # 1. passwordを暗号化する
  # 2. password_digest => password
  # 3. password_confirmationという属性を追加する
  # 4. password_confirmationとpasswordが同じか検証する
  # 5. authenticateメソッドを使えるようにする
  # 6. 最大文字数を72文字にする
  # 7. User.create時、入力必須にする
  has_secure_password

  # validates
  validates :name, presence: true,        # 入力必須
            length: {                     # 文字数制限
              maximum: 30,                # 最大文字数
              allow_blank: true           # 空白の場合はスキップ
            }

  VALID_PASSWORD_REGEX = /\A[\w\-]+\z/
  # \A     => 文字列の先頭
  # [\w\-] => 半角英数字とハイフン
  # +      => 直前の文字の1回以上の繰り返し
  # \z     => 文字列の末尾
  validates :password, presence: true,    # 入力必須
            length: {
              minimum: 8,                 # 最小文字数
              allow_blank: true
            },
            format: {                     # 正規表現
              with: VALID_PASSWORD_REGEX, # 半角英数字とハイフンのみ
              message: :invalid_password, # エラーメッセージ
              allow_blank: true
            },
            allow_nil: true               # nil(null)の場合はスキップ

  enum role: { other: 0, sales: 5, designer: 10, engineer: 15, manager: 20 }
  enum permission: { guest: 0, viewer: 5, editor: 10, admin: 15 }

end
