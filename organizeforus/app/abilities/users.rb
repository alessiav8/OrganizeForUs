Canard::Abilities.for(:user) do
  can [:read, :create, :update, :destroy], Group
  can [:read, :create, :update, :destroy], Event
  can [:read, :create, :update, :destroy], Post
  can [:read, :create, :update, :destroy], Comment
  can [:read, :create, :update, :destroy], Survey
end
