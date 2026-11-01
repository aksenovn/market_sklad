class RegistrationsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(registration_params)
    @user.role = "customer"

    if @user.save
      reset_session
      session[:user_id] = @user.id

      redirect_to root_path,
                  notice: "Регистрация завершена. Добро пожаловать!",
                  status: :see_other
    else
      render :new, status: :unprocessable_content
    end
  end

  private

  def registration_params
    params.expect(user: [
      :name, :email_address, :password, :password_confirmation
    ])
  end
end
