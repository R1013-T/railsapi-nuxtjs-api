class Api::V1::UsersController < ApplicationController

  def index
    users = User.all
    # as_jsonメソッドは、ハッシュを返す
    render json: users.as_json(only: [:id, :name, :email, :role, :permission, :created_at, :updated_at])
  end

end
