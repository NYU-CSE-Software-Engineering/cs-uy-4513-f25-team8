class Api::V1::DisputesController < ApplicationController
  before_action :authenticate_user_for_api
  before_action :ensure_user_can_create_dispute, only: [:create]

  def create
    item = Item.find_by(id: params[:itemID])

    if item.nil?
      render json: { success: false, error: "Item not found" }, status: :not_found
      return
    end

    existing = Dispute.find_by(item: item, created_by: current_user)
    if existing
      render json: { success: false, error: "You have already reported this listing.", dispute_id: existing.id, status: existing.status }, status: :unprocessable_entity
      return
    end

    dispute = Dispute.new(
      item: item,
      booking_id: params[:booking_id],
      created_by: current_user,
      reason: params[:reason],
      details: params[:details],
      status: "open"
    )

    if dispute.save
      item.owner.increment!(:report_count)
      render json: { success: true, dispute_id: dispute.id, status: dispute.status }
    else
      render json: { success: false, error: dispute.errors.full_messages.join(", ") }, status: :unprocessable_entity
    end
  end

  def mine
    disputes = current_user.disputes_created.order(created_at: :desc)

    payload = disputes.map do |dispute|
      {
        id: dispute.id,
        itemID: dispute.item_id,
        reason: dispute.reason,
        details: dispute.details,
        status: dispute.status,
        created_at: dispute.created_at,
        resolved_at: dispute.resolved_at,
        resolution_notes: dispute.resolution_notes
      }
    end

    render json: { disputes: payload }
  end

  private

  def authenticate_user_for_api
    unless user_signed_in?
      render json: { error: "Unauthorized" }, status: :unauthorized
      return
    end
  end

  def ensure_user_can_create_dispute
    item = Item.find_by(id: params[:itemID])

    if item.nil?
      render json: { error: "Item not found" }, status: :not_found
      return
    end

    # Allow any authenticated user to report, except the listing owner
    if current_user == item.owner
      render json: { error: "Owners cannot report their own listings" }, status: :unauthorized
      return
    end
  end
end

