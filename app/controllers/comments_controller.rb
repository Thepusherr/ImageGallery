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

    Rails.logger.info("Creating comment for post #{@post.id} by user #{current_user.id}: #{text}")

    if text.blank?
      Rails.logger.warn("Comment text is blank")
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("post#{@post.id}comment_form", partial: "posts/comment_form_vanilla", locals: { post: @post, error: "Comment cannot be empty" }) }
        format.html { redirect_to @post, alert: "Comment cannot be empty" }
      end
      return
    end

    @comment = @post.comments.new(user: current_user, text: text)

    if @comment.save
      Rails.logger.info("Comment created successfully: #{@comment.id}")

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

      # Принудительно перезагружаем пост с комментариями
      @post = Post.find(@post.id)
      @post.reload

      respond_to do |format|
        format.turbo_stream # Будет использовать create.turbo_stream.haml
        format.html { redirect_back(fallback_location: @post) }
      end
    else
      Rails.logger.error("Failed to create comment: #{@comment.errors.full_messages}")
      respond_to do |format|
        format.html { redirect_back(fallback_location: @post, alert: @comment.errors.full_messages.join(', ')) }
        format.turbo_stream { render turbo_stream: turbo_stream.replace("post#{@post.id}comment_form", partial: "posts/comment_form", locals: { post: @post, error: @comment.errors.full_messages.join(', ') }) }
      end
    end
  rescue => e
    Rails.logger.error("Error creating comment: #{e.message}")
    Rails.logger.error(e.backtrace.join("\n"))
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace("post#{@post.id}comment_form", partial: "posts/comment_form", locals: { post: @post, error: "An error occurred while creating the comment" }) }
      format.html { redirect_back(fallback_location: @post, alert: "An error occurred while creating the comment") }
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
