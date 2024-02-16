class PostsController < InheritedResources::Base

  private

  def post_params
    params.require(:post).permit(:title, :text)
  end

  def show
    @comment = @post.comments.build
  end
end
