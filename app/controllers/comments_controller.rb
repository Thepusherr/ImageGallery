class CommentsController < InheritedResources::Base

  private

  def comment_params
    params.require(:comment).permit(:post_id, :text)
  end

  def create
    @comment = Comment.new(comment_params)

    respond_to do |format|
      if @comment.save
        format.html { redirect_to @comment.post, notice: "Comment was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end
end
