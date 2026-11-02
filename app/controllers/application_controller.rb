class ApplicationController < ActionController::Base
  allow_browser versions: :modern

  stale_when_importmap_changes

  helper_method :current_user, :logged_in?, :employee?

  private

  def current_user
    return @current_user if defined?(@current_user)

    @current_user = User.find_by(id: session[:user_id])
  end

  def logged_in?
    current_user.present?
  end

  def employee?
    current_user&.employee? || false
  end

  def require_employee
    return if employee?

    respond_to do |format|
      format.html do
        if logged_in?
          redirect_to root_path,
                      alert: "Это действие доступно только сотрудникам.",
                      status: :see_other
        else
          redirect_to new_session_path,
                      alert: "Для этого действия войдите в аккаунт сотрудника.",
                      status: :see_other
        end
      end

      format.json do
        message = if logged_in?
          "Это действие доступно только сотрудникам."
        else
          "Необходимо войти в аккаунт сотрудника."
        end

        render json: { error: message },
               status: logged_in? ? :forbidden : :unauthorized
      end
    end
  end
end
