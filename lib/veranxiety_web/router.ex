defmodule VeranxietyWeb.Router do
  use VeranxietyWeb, :router
  import VeranxietyWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash

    plug :put_root_layout, {VeranxietyWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # Public routes
  scope "/", VeranxietyWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  # Authentication routes
  scope "/", VeranxietyWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{VeranxietyWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live "/users/register", UserRegistrationLive, :new
      live "/users/log_in", UserLoginLive, :new
      live "/users/reset_password", UserForgotPasswordLive, :new
      live "/users/reset_password/:token", UserResetPasswordLive, :edit
    end

    post "/users/log_in", UserSessionController, :create
  end

  # Authenticated routes
  scope "/", VeranxietyWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{VeranxietyWeb.UserAuth, :ensure_authenticated}] do
      live "/sessions", SessionLive.Index, :index
      live "/sessions/new", SessionLive.Index, :new
      live "/sessions/:id/edit", SessionLive.Index, :edit
      live "/sessions/:id", SessionLive.Show, :show

      live "/allergy_entries", AllergyEntryLive, :index
      live "/allergy_entries/new", AllergyEntryLive, :new
      live "/allergy_entries/:id/edit", AllergyEntryLive, :edit

      live "/users/settings", UserSettingsLive, :edit
      live "/users/settings/confirm_email/:token", UserSettingsLive, :confirm_email
    end
  end

  # Routes accessible to both authenticated and unauthenticated users
  scope "/", VeranxietyWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete

    live_session :current_user,
      on_mount: [{VeranxietyWeb.UserAuth, :mount_current_user}] do
      live "/users/confirm/:token", UserConfirmationLive, :edit
      live "/users/confirm", UserConfirmationInstructionsLive, :new
    end
  end

  # Enable LiveDashboard in development
  if Application.compile_env(:veranxiety, :dev_routes) do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: VeranxietyWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
