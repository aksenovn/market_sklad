class SessionsController < ApplicationController
  rate_limit to: 10, within: 3.minutes, only: :create,
             with: -> {
               redirect_to new_session_path,
                           alert: "Слишком много попыток. Попробуйте через несколько минут.",
                           status: :see_other
             }

  def new
  end

  def create
    credentials = params.expect(session: [ :email_address, :password ])

    user = User.find_by(
      email_address: credentials[:email_address].to_s.strip.downcase
    )

    if user&.authenticate(credentials[:password].to_s)
      reset_session
      session[:user_id] = user.id

      redirect_to root_path,
                  notice: "Вы вошли в аккаунт.",
                  status: :see_other
    else
      flash.now[:alert] = "Неверная почта или пароль."
      render :new, status: :unprocessable_content
    end
  end

  def destroy
    reset_session

    redirect_to root_path,
                notice: "Вы вышли из аккаунта.",
                status: :see_other
  end
end
