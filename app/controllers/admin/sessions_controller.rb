module Admin
  class SessionsController < ApplicationController
    layout "authentification"

    skip_before_action :authenticate!, only: %i[new create]
    before_action :set_session, only: :destroy

    def new
      render "sessions/new"
    end

    def create
      user = User.authenticate_by(email: params[:email], password: params[:password])
      if user&.admin?
        @session = user.sessions.create!
        cookies.signed.permanent[:session_token] = { value: @session.id, httponly: true }

        redirect_to Avo.configuration.root_path || dashboard_path, notice: "Signed in as admin"
      else
        redirect_to admin_login_path(email_hint: params[:email]), alert: "That email or password is incorrect or you are not an admin"
      end
    end

    def destroy
      @session.destroy
      redirect_back(fallback_location: admin_login_path, notice: "That session has been logged out")
    end

    private

    def set_session
      @session = Current.user.sessions.find(params[:id])
    end
  end
end
