class PostsForBranchService
  def initialize(params)
    @search = params[:search]
    @category = params[:category]
    @branch = params[:branch]
  end

  def call
    #εΕπιστρέφονται posts ανάλογα με τα φίλτρα αναζήτησης
    if @category.blank? && @search.blank?
      # χωρίς φίλτρα
      Post.by_branch(@branch).all
    elsif @category.blank? && @search.present?
      #αναζήτηση μόνο κειμένου
      Post.by_branch(@branch).search(@search)
    elsif @category.present? && @search.blank?
      # φίλτρο κατηγορίας
      Post.by_category(@branch, @category)
    else
      #και κατηγορία και αναζήτηση
      Post.by_category(@branch, @category).search(@search)
    end
  end
end