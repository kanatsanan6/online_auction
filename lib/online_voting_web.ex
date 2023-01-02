defmodule OnlineVotingWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use OnlineVotingWeb, :controller
      use OnlineVotingWeb, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """

  def controller do
    quote do
      use Phoenix.Controller, namespace: OnlineVotingWeb

      import Plug.Conn
      import OnlineVotingWeb.Gettext
      alias OnlineVotingWeb.Router.Helpers, as: Routes
      alias OnlineVotingWeb.Helpers.Auth, as: Auth
    end
  end

  def helper do
    quote do
      use Phoenix.Controller, namespace: OnlineVotingWeb

      import Plug.Conn
      import OnlineVotingWeb.Gettext
      alias OnlineVotingWeb.Router.Helpers, as: Routes
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/online_voting_web/templates",
        namespace: OnlineVotingWeb

      # Import convenience functions from controllers
      import Phoenix.Controller,
        only: [get_flash: 1, get_flash: 2, view_module: 1, view_template: 1]

      # Include shared imports and aliases for views
      unquote(view_helpers())

      import OnlineVotingWeb.Helpers.Auth
    end
  end

  def live_view do
    quote do
      use Phoenix.LiveView,
        layout: {OnlineVotingWeb.LayoutView, "live.html"}

      on_mount OnlineVotingWeb.Helpers.LiveAuth
      unquote(view_helpers())

      alias OnlineVotingWeb.Router.Helpers, as: Routes
      alias OnlineVotingWeb.Helpers.Auth, as: Auth
      import OnlineVotingWeb.Helpers.LiveAuth
    end
  end

  def live_component do
    quote do
      use Phoenix.LiveComponent

      unquote(view_helpers())
    end
  end

  def component do
    quote do
      use Phoenix.Component

      unquote(view_helpers())
    end
  end

  def router do
    quote do
      use Phoenix.Router

      import Plug.Conn
      import Phoenix.Controller
      import Phoenix.LiveView.Router
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import OnlineVotingWeb.Gettext
    end
  end

  defp view_helpers do
    quote do
      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      # Import LiveView and .heex helpers (live_render, live_patch, <.form>, etc)
      import Phoenix.LiveView.Helpers
      import OnlineVotingWeb.LiveHelpers

      # Import basic rendering functionality (render, render_layout, etc)
      import Phoenix.View

      import OnlineVotingWeb.ErrorHelpers
      import OnlineVotingWeb.Gettext
      alias OnlineVotingWeb.Router.Helpers, as: Routes
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
