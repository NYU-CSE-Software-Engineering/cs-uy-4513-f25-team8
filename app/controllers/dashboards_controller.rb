class DashboardsController < ApplicationController
  def show
    render inline: <<~HTML
      <title>User Dashboard</title>
      <h1>Welcome back!</h1>
      <a href="/dashboard">Dashboard</a>
    HTML
  end
end
