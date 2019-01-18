defmodule Rumbl.User do 
	
	use Ecto.Schema
	import Ecto.Changeset 
	alias Rumbl.User

	schema "users" do 
		field :name, :string 
		field :username, :string, null: false 
		field :password, :string, virtual: true 
		field :password_hash, :string 

		timestamps()

	end 

	def changeset(%User{} = user, attrs) do 
		user
		|> cast(attrs, [:name, :username, :password, :password_hash])
		|> validate_required([:username])
		|> validate_length(:password, min: 6, max: 20)
		 
	end 

	def registration_changeset(user, attrs) do 
		user
		|> changeset(attrs)
		|> cast(attrs, [:password])
		|> put_pass_hash()
	end 

	defp put_pass_hash(user) do 
		case user do 
			%Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
				put_change(user, :password_hash, Comeonin.Pbkdf2.hashpwsalt(pass))
					_ ->
						user
			end 
    end 

end