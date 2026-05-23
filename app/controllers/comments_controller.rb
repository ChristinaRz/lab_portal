class CommentsController < ApplicationController
  #υποχρεωτικό login για σχολιασμό
  before_action :authenticate_user!
  #post από το nested route
  before_action :set_post

  # POST /posts/:post_id/comments
  def create
    @comment = @post.comments.new(comment_params)
    #τρέχων χρήστης ορίζεται ως συγγραφέας
    @comment.user = current_user

    if @comment.save
      redirect_to @post, notice: 'Comment added.'
    else
      redirect_to @post, alert: 'Comment failed. It cannot be empty.'
    end
  end

  # DELETE /posts/:post_id/comments/:id
  def destroy
    #αναζήτηση μόνο μέσα στα comments του συγκεκριμένου post
    comment = @post.comments.find(params[:id])

    #μόνο ο ιδιοκτήτης μπορεί να διαγράψει το comment
    unless comment.user == current_user
      return redirect_to @post, alert: 'Not allowed.'
    end

    comment.destroy
    redirect_to @post, notice: 'Comment deleted.'
  end

  private

  def set_post
    #το post_id έρχεται από το nested route
    @post = Post.find(params[:post_id])
  end

  def comment_params
    #επιτρέπεται μόνο το body
    #με wrapper :comment
     params.require(:comment).permit(:body)
    end
end