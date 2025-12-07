class SessionsController < ApplicationController
  skip_forgery_protection only: :create

  def new
    render inline: <<~HTML
      <h1>Log in</h1>
      <form action="/login" method="post">
        <label for="email">Email</label><input type="text" name="email" id="email">
        <label for="password">Password</label><input type="password" name="password" id="password">
        <button type="submit">Log in</button>
      </form>
    HTML
  end

  def create
    user = User.find_by(email: params[:email])
    
    if user && user.valid_password?(params[:password])
      if user.account_status == 'disabled'
        redirect_to "/login", alert: "Your account has been disabled."
      else
        session[:user_id] = user.id
        redirect_to "/dashboard", notice: "Welcome back!"
      end
    else
      redirect_to "/login", alert: "Invalid email or password."
    end
  end
end
