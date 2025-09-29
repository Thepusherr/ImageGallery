class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_category
  
  def create
    @subscription = current_user.subscriptions.build(category: @category)
    
    respond_to do |format|
      if @subscription.save
        # Log the subscription event if UserEventLogger is available
        if defined?(UserEventLogger)
          begin
            UserEventLogger.log(
              user: current_user,
              action_type: 'subscribed',
              url: category_path(@category)
            )
          rescue => e
            Rails.logger.error("Failed to log subscription event: #{e.message}")
          end
        end
        
        # Send subscription confirmation email
        begin
          NotifierMailer.category_subscription(current_user, @category).deliver_later
        rescue => e
          Rails.logger.error("Failed to send subscription email: #{e.message}")
        end
        
        format.html { redirect_to category_path(@category), notice: "You have successfully subscribed to #{@category.name}." }
        format.turbo_stream { render turbo_stream: turbo_stream.replace("category_subscription_#{@category.id}", partial: "categories/subscription", locals: { category: @category }) }
      else
        format.html { redirect_to category_path(@category), alert: "Failed to subscribe: #{@subscription.errors.full_messages.join(', ')}" }
        format.turbo_stream { head :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @subscription = current_user.subscriptions.find_by(category: @category)
    
    respond_to do |format|
      if @subscription&.destroy
        # Log the unsubscription event if UserEventLogger is available
        if defined?(UserEventLogger)
          begin
            UserEventLogger.log(
              user: current_user,
              action_type: 'unsubscribed',
              url: category_path(@category)
            )
          rescue => e
            Rails.logger.error("Failed to log unsubscription event: #{e.message}")
          end
        end
        
        format.html { redirect_to category_path(@category), notice: "You have unsubscribed from #{@category.name}." }
        format.turbo_stream { render turbo_stream: turbo_stream.replace("category_subscription_#{@category.id}", partial: "categories/subscription", locals: { category: @category }) }
      else
        format.html { redirect_to category_path(@category), alert: "Failed to unsubscribe." }
        format.turbo_stream { head :unprocessable_entity }
      end
    end
  end
  
  private
  
  def set_category
    @category = Category.friendly.find(params[:category_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to categories_path, alert: "Category not found."
  end
end