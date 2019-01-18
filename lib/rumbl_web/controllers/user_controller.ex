defmodule RumblWeb.UserController do 
	use RumblWeb, :controller 
	plug :authenticate when action in [:index, :show]

	alias RumblWeb.Router.Helpers

	alias Rumbl.{User, Repo}

	def new(conn, _params) do 
		changeset = User.changeset(%User{}, %{})
		render(conn, "new.html", changeset: changeset)
	end 

	def index(conn, _params) do
		users = Repo.all(User)
		render conn, "index.html", users: users
	end  

	def show(conn, %{ "id" => id}) do 
		user = Repo.get!(User, id)
		render(conn, "show.html", user: user)
	end 

	def edit(conn, %{ "id" => id}) do  
		user = Repo.get!(User, id)
		render conn, "edit.html", user: user 
	end

	def create(conn, %{"user" => user_params}) do 
		changeset = User.registration_changeset(%User{}, user_params)
		case Repo.insert(changeset) do 
			{:ok, user} ->
				conn
				|> Rumbl.Auth.login(user)
				|> put_flash(:info, "#{user.name} created!")
				|> redirect(to: Helpers.user_path(conn, :index))
			{:error, changeset} ->
				render(conn, "new.html", changeset: changeset)
		  end 
	end 

		defp authenticate(conn, _opts) do
			if conn.assigns.current_user do 
				conn
			else 
				conn
				|> put_flash(:error, "You must be logged in to access that page")
				|> redirect(to: RumblWeb.Router.Helpers.page_path(conn, :index))
				|> halt()
			end 
		end 

end 