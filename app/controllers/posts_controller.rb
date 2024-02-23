class PostsController < InheritedResources::Base
  def create
    Post.create!(post_params)
  end

  def show
    @comment = @post.comments.build
  end

  private

  def post_params
    params.require(:post).permit(:title, :text, :image)
  end
end
