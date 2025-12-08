class ContactsController < ApplicationController
  def new
    @contact = Contact.new
    # Pre-fill if user is signed in
    if user_signed_in?
      @contact.name = current_user.username
      @contact.email = current_user.email
    end
  end

  def create
    @contact = Contact.new(contact_params)
    @contact.user = current_user if user_signed_in?

    if @contact.save
      redirect_to root_path, notice: "Thank you for your message! We'll get back to you soon."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def contact_params
    params.require(:contact).permit(:name, :email, :subject, :message)
  end
end
