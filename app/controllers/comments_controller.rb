class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: [:create]

  def create
    comment_params = params[:comment] || {}
    @comment = @post.comments.new(user: current_user, text: comment_params[:text])

    if @comment.save
      # Log the comment event if UserEventLogger is available
      if defined?(UserEventLogger)
        begin
          UserEventLogger.log(
            user: current_user,
            action_type: 'commented',
            url: request.fullpath || '/'
          )
        rescue => e
          Rails.logger.error("Failed to log user event: #{e.message}")
        end
      end
      
      respond_to do |format|
        format.html { redirect_to post_path(@post), notice: 'Comment was successfully created.' }
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "post#{@post.id}comments",
            partial: "posts/post_comments",
            locals: { post: @post }
          )
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to post_path(@post), alert: 'Failed to create comment.' }
        format.turbo_stream { head :unprocessable_entity }
      end
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @post = @comment.post
    
    if @comment.user == current_user
      @comment.destroy
      respond_to do |format|
        format.html { redirect_to post_path(@post), notice: 'Comment was successfully deleted.' }
        format.turbo_stream do
          render turbo_stream: turbo_stream.remove(
            "post#{@comment.post_id}ModalComment#{@comment.id}"
          )
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to post_path(@post), alert: 'You are not authorized to delete this comment.' }
        format.turbo_stream { head :forbidden }
      end
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end
end
