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
        format.html { 
          if request.xhr?
            # Для AJAX-запросов возвращаем Turbo Stream
            render template: "comments/create", formats: [:turbo_stream]
          else
            redirect_to post_path(@post), notice: 'Comment was successfully created.'
          end
        }
        format.turbo_stream
        format.json { render json: { success: true } }
        format.js
      end
    else
      respond_to do |format|
        format.html { 
          if request.xhr?
            render template: "comments/error", formats: [:turbo_stream], status: :unprocessable_entity
          else
            redirect_to post_path(@post), alert: 'Failed to create comment.'
          end
        }
        format.turbo_stream { render template: "comments/error" }
        format.json { render json: { success: false, errors: @comment.errors.full_messages }, status: :unprocessable_entity }
        format.js { render template: "comments/error" }
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
        format.turbo_stream
      end
    else
      respond_to do |format|
        format.html { redirect_to post_path(@post), alert: 'You are not authorized to delete this comment.' }
        format.turbo_stream { render template: "comments/destroy_error" }
      end
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end
end
