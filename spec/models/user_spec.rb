require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }

  context "バリデーション" do
    it "名前、メールアドレスがあれば有効な状態であること" do
      expect(user).to be_valid
    end

    it "名前がなければ無効な状態であること" do
      user = build(:user, name: nil)
      user.valid?
      expect(user.errors[:name]).to include("を入力してください")
    end

    it "名前が50文字以内であること" do
      user = build(:user, name: "a" * 51)
      user.valid?
      expect(user.errors[:name]).to include("は50文字以内で入力してください")
    end

    it "メールアドレスがなければ無効な状態であること" do
      user = build(:user, email: nil)
      user.valid?
      expect(user.errors[:email]).to include("を入力してください")
    end

    it "メールアドレスが255文字以内であること" do
      user = build(:user, email: "a" * 256)
      user.valid?
      expect(user.errors[:email]).to include("は255文字以内で入力してください")
    end

    it "メールアドレスが全て小文字で保存されること" do
      email = "ExamPle@example.com"
      user = create(:user, email: email)
      expect(user.email).to eq email.downcase
    end

    it "重複したメールアドレスなら無効な状態であること" do
      other_user = build(:user, email: user.email)
      other_user.valid?
      expect(other_user.errors[:email]).to include("はすでに存在します")
    end

    it "パスワードがなければ無効な状態であること" do
      user = build(:user, password: nil, password_confirmation: nil)
      user.valid?
      expect(user.errors[:password]).to include("を入力してください")
    end

    it "パスワードが6文字以上であること" do
      user = build(:user, password: "taka", password_confirmation: "taka")
      user.valid?
      expect(user.errors[:password]).to include("は6文字以上で入力してください")
    end

    it "パスワードが有効であること" do
      user = build(:user, password: "takahiro", password_confirmation: "takahiro")
      user.valid?
      expect(user).to be_valid
    end

    context "authenticated?メソッド" do
      it "ダイジェストが存在しない場合、falseを返すこと" do
        expect(user.authenticated?(:remember, '')).to be_falsy
      end
    end

    context "フォロー機能" do
      it "フォローとアンフォローが正常に動作すること" do
        expect(user.following?(other_user)).to be_falsey
        user.follow(other_user)
        expect(user.following?(other_user)).to be_truthy
        expect(other_user.followed_by?(user)).to be_truthy
        user.unfollow(other_user)
        expect(user.following?(other_user)).to be_falsey
      end
    end
  end
end
