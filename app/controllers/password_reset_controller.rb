class PasswordResetsController < ApplicationController
  # Step 1: Show username form
  def username_form
  end

  # Step 1b: Verify username & load questions
  def verify_username
    @user = User.find_by(username: params[:username])

    if @user.nil?
      flash[:alert] = "Username not found."
      redirect_to password_reset_path
    else
      session[:password_reset_user_id] = @user.id
      redirect_to password_reset_questions_path
    end
  end

  # Step 2: Show security questions
  def security_questions
    @user = User.find_by(id: session[:password_reset_user_id])

    if @user.nil?
      redirect_to password_reset_path, alert: "Session expired. Try again."
    end
  end

  # Step 2b: Verify answers
  def verify_answers
    @user = User.find_by(id: session[:password_reset_user_id])

    if @user.nil?
      redirect_to password_reset_path, alert: "Session expired. Try again."
      return
    end

    correct_q1 = @user.security_answer_1.strip.downcase == params[:answer_1].strip.downcase
    correct_q2 = @user.security_answer_2.strip.downcase == params[:answer_2].strip.downcase

    if correct_q1 && correct_q2
      redirect_to password_reset_new_path
    else
      flash[:alert] = "Security answers were incorrect."
      redirect_to password_reset_questions_path
    end
  end

  # Step 3: New password form
  def new_password
    @user = User.find_by(id: session[:password_reset_user_id])

    redirect_to password_reset_path, alert: "Session expired." if @user.nil?
  end

  # Step 3b: Update password
  def update_password
    @user = User.find_by(id: session[:password_reset_user_id])

    if @user.nil?
      redirect_to password_reset_path, alert: "Session expired."
      return
    end

    if params[:password].blank?
      flash[:alert] = "Password cannot be blank."
      redirect_to password_reset_new_path
      return
    end

    if @user.update(password: params[:password], password_confirmation: params[:password_confirmation])
      session.delete(:password_reset_user_id)
      redirect_to new_user_session_path, notice: "Password updated successfully. Please sign in."
    else
      flash[:alert] = @user.errors.full_messages.join(", ")
      redirect_to password_reset_new_path
    end
  end
end
