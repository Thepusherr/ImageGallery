class CommentsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_post, only: [:create]

  def new
    @comment = Comment.new
    # Для тестов
    if params[:post_id]
      @post = Post.find(params[:post_id])
    end
  end

  def create
    # Получаем текст комментария из параметров формы
    text = params[:text]
    
    @comment = @post.comments.new(user: current_user, text: text)

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
        format.turbo_stream { render turbo_stream: turbo_stream.replace("post#{@post.id}comments", partial: "posts/post_comments", locals: { post: @post }) }
        format.html { redirect_to @post }
      end
    else
      respond_to do |format|
        format.html { render turbo_stream: turbo_stream.replace("post#{@post.id}comment_form", partial: "posts/comment_form_vanilla", locals: { post: @post, error: @comment.errors.full_messages.join(', ') }) }
        format.turbo_stream { render turbo_stream: turbo_stream.replace("post#{@post.id}comment_form", partial: "posts/comment_form_vanilla", locals: { post: @post, error: @comment.errors.full_messages.join(', ') }) }
      end
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @post = @comment.post
    
    if @comment.user == current_user
      @comment.destroy
      respond_to do |format|
        format.html { redirect_to post_path(@post), notice: t('comments.deleted_successfully') }
        format.turbo_stream
      end
    else
      respond_to do |format|
        format.html { redirect_to post_path(@post), alert: t('comments.unauthorized') }
        format.turbo_stream { render template: "comments/destroy_error" }
      end
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end
end
