class CommentsController < InheritedResources::Base
  before_action :set_post, only: [:create]

  def create
    @comment = @post.comments.create(user: current_user, text: params[:comment_text])

    if @comment.persisted?
      UserEventLogger.log(
        user: current_user,
        action_type: 'commented',
        url: url_for(:only_path => false) # request.fullpath
      )
    end

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "post#{@post.id}comments",
          partial: "posts/post_comments",
          locals: { post: @post }
        )
      end
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    if @comment.user == current_user
      @comment.destroy
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.remove(
            "post#{@comment.post_id}ModalComment#{@comment.id}"
          )
        end
      end
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end
end
