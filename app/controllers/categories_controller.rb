class CategoriesController < ApplicationController
  before_action :set_category, only: [:edit, :show, :update]
  before_action :require_admin, except: [:show, :index]

  def new
    @category = Category.new
  end

  def index
    @categories = Category.paginate(page: params[:page], per_page: 5).custom_display
  end

  def edit
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      flash[:notice] = "Category has been added successfully!"
      redirect_to @category
    else
      render 'new'
    end
  end

  def show
    @articles = @category.articles.paginate(page: params[:page], per_page: 5)
  end

  def update
    if @category.update(category_params)
      flash[:notice] = "Category name has been updated successfully!"
      redirect_to @category
    else
      render 'edit'
    end
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name)
  end

  def require_admin
    if !(logged_in? && current_user.admin?)
      flash[:alert] = "You must have admin privileges to perform that action!"
      redirect_to categories_path
    end
  end

end