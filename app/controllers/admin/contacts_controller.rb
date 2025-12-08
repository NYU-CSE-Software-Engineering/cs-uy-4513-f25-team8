class Admin::ContactsController < ApplicationController
  include AdminAuthorization

  def index
    @contacts = Contact.all.order(created_at: :desc)
    
    if params[:search].present?
      search_term = "%#{params[:search]}%"
      @contacts = @contacts.where("name LIKE ? OR email LIKE ? OR subject LIKE ?", search_term, search_term, search_term)
    end
  end

  def show
    @contact = Contact.find(params[:id])
  end
end
