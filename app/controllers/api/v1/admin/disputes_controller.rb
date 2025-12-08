class Api::V1::Admin::DisputesController < ApplicationController
  before_action :authenticate_user_for_api
  before_action :ensure_admin_for_index
  skip_before_action :ensure_admin_for_index, only: [:create]
  before_action :ensure_user_can_create_dispute, only: [:create]

  def index
    @disputes = Dispute.all.order(created_at: :desc)
    
    disputes_data = @disputes.map do |dispute|
      {
        itemID: dispute.item_id,
        dispute_details: {
          id: dispute.id,
          reason: dispute.reason,
          details: dispute.details,
          status: dispute.status,
          created_by: dispute.created_by.username,
          created_at: dispute.created_at,
          resolved_by: dispute.resolved_by&.username,
          resolved_at: dispute.resolved_at,
          resolution_notes: dispute.resolution_notes
        }
      }
    end
    
    render json: { disputes: disputes_data }
  end

  def create
    item = Item.find_by(id: params[:itemID])
    
    if item.nil?
      render json: { success: false, error: "Item not found" }, status: :not_found
      return
    end

    dispute = Dispute.new(
      item: item,
      created_by: current_user,
      reason: params[:reason] || 'Reported by user',
      details: params[:dispute_details] || params[:details] || '',
      status: 'open'
    )

    if dispute.save
      item.owner.increment!(:report_count)
      render json: { success: true }
    else
      render json: { success: false, error: dispute.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  private

  def authenticate_user_for_api
    unless user_signed_in?
      render json: { error: "Unauthorized" }, status: :unauthorized
      return
    end
  end

  def ensure_admin_for_index
    unless current_user&.role == 'admin'
      render json: { error: "Unauthorized" }, status: :unauthorized
    end
  end

  def ensure_user_can_create_dispute
    # User must be renter or owner of the item, or admin
    item = Item.find_by(id: params[:itemID])
    
    if item.nil?
      render json: { error: "Item not found" }, status: :not_found
      return
    end

    # Check if user is authorized: admin, owner, or renter with a booking
    is_admin = current_user&.role == 'admin'
    is_owner = current_user == item.owner
    is_renter_with_booking = current_user&.role == 'renter' && Booking.exists?(item_id: item.id, renter_id: current_user.id)
    
    unless is_admin || is_owner || is_renter_with_booking
      render json: { error: "Unauthorized" }, status: :unauthorized
      return
    end
  end
end

