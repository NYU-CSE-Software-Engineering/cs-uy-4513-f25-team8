class SecurityQuestionsController < ApplicationController
  # Step 1 — Look up user by username
  def lookup
    @user = User.find_by(username: params[:username])

    unless @user
      flash[:alert] = "Username not found."
      return redirect_to new_user_password_path
    end

    # Continue to show their security questions
    redirect_to security_questions_verify_path(@user.id)
  end

  # Step 2 — Show the user their two questions
  def verify
    @user = User.find_by(id: params[:id])

    unless @user
      flash[:alert] = "User not found."
      redirect_to new_user_password_path
    end
  end

  # Step 3 — Check answers
  def check_answers
    @user = User.find_by(id: params[:id])

    unless @user
      flash[:alert] = "User not found."
      return redirect_to new_user_password_path
    end

    if params[:answer_1].to_s.downcase.strip == @user.security_answer_1.to_s.downcase.strip &&
       params[:answer_2].to_s.downcase.strip == @user.security_answer_2.to_s.downcase.strip

      # Answers correct → Go to password reset page
      redirect_to security_questions_reset_password_path(@user.id)
    else
      flash[:alert] = "Incorrect answers. Please try again."
      redirect_to security_questions_verify_path(@user.id)
    end
  end

  # Step 4 — Show password reset form
  def reset_password
    @user = User.find_by(id: params[:id])

    unless @user
      flash[:alert] = "User not found."
      redirect_to new_user_password_path
    end
  end

  # Step 5 — Update password
  def update_password
    @user = User.find_by(id: params[:id])

    unless @user
      flash[:alert] = "User not found."
      return redirect_to new_user_password_path
    end

    if @user.update(password_params)
      flash[:notice] = "Password updated successfully. Please sign in."
      redirect_to new_user_session_path
    else
      flash[:alert] = @user.errors.full_messages.join(", ")
      render :reset_password
    end
  end

  private

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
