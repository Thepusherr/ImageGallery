class LikesController < InheritedResources::Base
  private

  def like_params
    params.require(:like).permit()
  end
end
