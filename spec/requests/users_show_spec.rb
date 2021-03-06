require 'rails_helper'

RSpec.describe "プロフィールページ", type: :request do
  let!(:user) { create(:user) }

  it "レスポンスが正常に表示されること" do
    login_for_request(user)
    get user_path(user)
    expect(response).to render_template('users/show')
  end
end
