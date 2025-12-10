class Api::V1::Admin::DisputesController < ApplicationController
  before_action :authenticate_user_for_api
  before_action :ensure_admin_for_index
  skip_before_action :ensure_admin_for_index, only: [:create]
  before_action :ensure_user_can_create_dispute, only: [:create]
  before_action :set_dispute, only: [:resolve]

  def index
    scope = params[:status].present? ? Dispute.where(status: params[:status]) : Dispute.all
    @disputes = scope.order(created_at: :desc)
    
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

    existing = Dispute.find_by(item: item, created_by: current_user)
    if existing
      render json: { success: false, error: "You have already reported this listing.", dispute_id: existing.id, status: existing.status }, status: :unprocessable_entity
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

  def resolve
    return unless @dispute

    unless current_user&.role == 'admin'
      render json: { error: "Unauthorized" }, status: :unauthorized
      return
    end

    status = params[:status].presence || 'resolved'
    unless %w[open resolved].include?(status)
      render json: { success: false, error: "Invalid status" }, status: :unprocessable_entity
      return
    end

    Dispute.transaction do
      @dispute.update!(
        status: status,
        resolved_by: current_user,
        resolved_at: Time.current,
        resolution_notes: params[:resolution_notes]
      )

      if ActiveModel::Type::Boolean.new.cast(params[:disable_account]) && @dispute.item&.owner
        @dispute.item.owner.update!(account_status: 'disabled')
      end
    end

    render json: { success: true, dispute_id: @dispute.id, status: @dispute.status }
  rescue ActiveRecord::RecordInvalid => e
    render json: { success: false, error: e.record.errors.full_messages.join(', ') }, status: :unprocessable_entity
  end

  private

  def set_dispute
    @dispute = Dispute.find_by(id: params[:id])
    return if @dispute.present?

    render json: { error: "Dispute not found" }, status: :not_found and return
  end

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
    item = Item.find_by(id: params[:itemID])
    
    if item.nil?
      render json: { error: "Item not found" }, status: :not_found
      return
    end

    is_admin = current_user&.role == 'admin'
    is_owner = current_user == item.owner
    is_renter_with_booking = current_user&.role == 'renter' && Booking.exists?(item_id: item.id, renter_id: current_user.id)

    unless is_admin || is_owner || is_renter_with_booking
      render json: { error: "Unauthorized" }, status: :unauthorized
      return
    end
  end
end

