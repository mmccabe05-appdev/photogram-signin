class UsersController < ApplicationController
  def sign_out
    reset_session
    redirect_to("/", { :notice => "Thanks for signing out" })
  end

  def new_session_form
    render({ :template => "users/signin_form.html.erb" })
  end

  def authenticate
    # get username and password from params
    un = params.fetch("input_username")

    # get password
    pw = params.fetch("input_password")
    # lookup record
    user = User.where({ :username => un }).at(0)

    # if no record, redirect to sign in
    if user == nil
      redirect_to("/user_sign_in", { :alert => "No such user exists" })

      # if record exists, check password
    else
      # if password matches render user page
      # if not redirect to sign in form
      # if so set cookie to logged in
      if user.authenticate(pw)
        session.store(:user_id, user.id)
        redirect_to("/", { :notice => "Welcome back, " + user.username })
      else
        redirect_to("/user_sign_in", { :alert => "Password incorrect" })
      end
    end
  end

  # render({:plain=>"hi"})

  def new_registration_form
    render({ :template => "users/signup_form.html.erb" })
  end

  def index
    @users = User.all.order({ :username => :asc })

    render({ :template => "users/index.html" })
  end

  def show
    the_username = params.fetch("the_username")
    @user = User.where({ :username => the_username }).at(0)

    render({ :template => "users/show.html.erb" })
  end

  def create
    user = User.new

    user.username = params.fetch("input_username")
    user.password = params.fetch("input_password")
    user.password_confirmation = params.fetch("input_password_confirmation")

    save_status = user.save

    if save_status == true
      redirect_to("/users/#{user.username}", { :notice => "Welcome, " + user.username + "!" })
      session.store(:user_id, user.id)
    else
      redirect_to("/user_sign_up", { :alert => user.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("the_user_id")
    user = User.where({ :id => the_id }).at(0)

    user.username = params.fetch("input_username")

    user.save

    redirect_to("/users/#{user.username}")
  end

  def destroy
    username = params.fetch("the_username")
    user = User.where({ :username => username }).at(0)

    user.destroy

    redirect_to("/users")
  end
end
