require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = active_user
  end

  test "name_validation" do

    # 入力必須
    user = User.new(email: "test@example.com", password: "password")
    user.save
    required_msg = ["名前を入力してください"]
    assert_equal(required_msg, user.errors.full_messages)

    # 最大文字数
    max = 30
    name = "a" * (max + 1)
    user.name = name
    user.save
    max_msg = ["名前は#{max}文字以内で入力してください"]
    assert_equal(max_msg, user.errors.full_messages)

    name = "あ" * max
    user.name = name
    assert_difference("User.count", 1) do
      user.save
    end

  end

  test "email_validation" do

    # 入力必須
    user = User.new(name: "test", password: "password")
    user.save
    required_msg = ["メールアドレスを入力してください"]
    assert_equal(required_msg, user.errors.full_messages)

    # 最大文字数
    max = 255
    domain = "@example.com"
    email = "a" * (max - domain.length + 1) + domain
    user.email = email
    user.save
    max_msg = ["メールアドレスは#{max}文字以内で入力してください"]
    assert_equal(max_msg, user.errors.full_messages)

    correct_emails = %w(
      A@A.com
    )
    correct_emails.each do |email|

      user.email = email
      assert user.save

    end

    incorrect_emails = %w(
      A@A,com
      A@A..com
      A@A_com
    )
    incorrect_emails.each do |email|

      user.email = email
      assert_not user.save
      invalid_msg = ["メールアドレスは不正な値です"]
      assert_equal(invalid_msg, user.errors.full_messages)

    end

  end

  test "email_downcase" do
    email = "USER.EXAMPLE.COM"
    user = User.new(name: "test", email: email, password: "password")
    user.save
    assert_equal(email.downcase, user.email)
  end

  test 'active_user_uniqueness' do
    email = "test@example.com"

    # アクティブユーザーが居ない場合保存できているか
    count = 3
    assert_difference("User.count", count) do
      count.times do |n|
        User.create(name: "test#{n}", email: email, password: "password")
      end
    end

    # アクティブユーザーが居る場合保存できていないか
    active_user = User.find_by(email: email)
    active_user.update(activated: true)
    assert active_user.activated

    assert_no_difference("User.count") do
      user = User.new(name: "test", email: email, password: "password")
      user.save
      unique_msg = ["メールアドレスはすでに存在します"]
      assert_equal(unique_msg, user.errors.full_messages)
    end

    # アクティブユーザーが居なくなった場合保存できているか
    active_user.destroy!
    assert_difference("User.count", 1) do
      User.create(name: "test", email: email, password: "password", activated: true)
    end

    # アクティブユーザーのemailの一意性は保証されているか
    assert_equal(1, User.where(email: email, activated: true).count)

  end

  test "password_validation" do

    # 入力必須
    user = User.new(name: "test", email: "test@example.com")
    user.save
    required_msg = ["パスワードを入力してください"]
    assert_equal(required_msg, user.errors.full_messages)

    # min文字以上
    min = 8
    user.password = "a" * (min - 1)
    user.save
    minlength_msg = ["パスワードは8文字以上で入力してください"]
    assert_equal(minlength_msg, user.errors.full_messages)

    # max文字以下
    max = 72
    user.password = "a" * (max + 1)
    user.save
    maxlength_msg = ["パスワードは72文字以内で入力してください"]
    assert_equal(maxlength_msg, user.errors.full_messages)

    # 書式チェック VALID_PASSWORD_REGEX = /\A[\w\-]+\z/
    correct_passwords = %w(
      pass---word
      ________
      12341234
      ____pass
      pass----
      PASSWORD
    )
    correct_passwords.each do |pass|
      user.password = pass
      assert user.save
    end

    incorrect_passwords = %w(
      pass/word
      pass.word
      |~=?+"a"
      １２３４５６７８
      ＡＢＣＤＥＦＧＨ
      password@
    )
    format_msg = ["パスワードは半角英数字・ハイフン・アンダーバーが使用できます"]
    incorrect_passwords.each do |pass|
      user.password = pass
      user.save
      assert_equal(format_msg, user.errors.full_messages)
    end

  end

end
