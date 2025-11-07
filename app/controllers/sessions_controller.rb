class SessionsController < ApplicationController
  skip_forgery_protection only: :create

  def new
    render inline: <<~HTML
      <h1>Log in</h1>
      <form action="/login" method="post">
        <label>Email</label><input type="text" name="email">
        <label>Password</label><input type="password" name="password">
        <button type="submit">Log in</button>
      </form>
    HTML
  end

  def create
    redirect_to "/dashboard", notice: "Welcome back!"
  end
end
