class TagsController < ApplicationController
  before_action :set_tag, only: [:show, :edit, :update, :destroy]
  before_action :destroy_all_selected, only: [:index]
  helper_method :sort_column, :sort_direction
  before_action :require_user, only: [:index, :show, :edit, :update, :destroy]
  
  # GET /tags
  # GET /tags.json
  def index
    session[:search_params] = params[:tag] ? params[:tag] : nil
    @o_all = current_user.tags.
                  search(session[:search_params]).
                  order(sort_column + " " + sort_direction).
                  paginate(:per_page => PER_PAGE, :page => params[:page])

    @params_arr = { :name => { "type" => 'text' } }

    @o_single = controller_name.classify.constantize.new
  end

  # GET /tags/1
  # GET /tags/1.json
  def show
  end

  # GET /tags/new
  def new
    @o_single = Tag.new
  end

  # GET /tags/1/edit
  def edit
  end

  # POST /tags
  # POST /tag_sessions
  # POST /tag_sessions.xml
  def create

    @o_single = Tag.new(tag_params)
    respond_to do |format|
      if @o_single.save
        format.html { redirect_to tags_url, notice: t("general.successfully_created") }
        format.json { head :no_content }
      else
        format.html { render action: 'new' }
        format.json { render json: @o_single.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tags/1
  # PATCH/PUT /tags/1.json
  def update
    respond_to do |format|
      if @o_single.update(tag_params)
        format.html { redirect_to tags_url, notice: t("general.successfully_updated") }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @o_single.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tags/1
  # DELETE /tags/1.json
  def destroy
    @o_single.destroy
    respond_to do |format|
      format.html { redirect_to tags_url, notice: t("general.successfully_destroyed") }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tag
      @o_single = Tag.find(params[:id])
    end

    def destroy_all_selected
      if params[:rec]
        id_arrs = params[:rec].collect { |k, v| k }
        Tag.find(id_arrs).map(&:destroy)
        flash[:notice] = t("general.successfully_destroyed")
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tag_params
      params.require(:tag).permit!
    end

    def set_header_menu_active
      @tags = "active"
    end

    def sort_column
      Tag.column_names.include?(params[:sort]) ? params[:sort] : "id"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
    end

end
