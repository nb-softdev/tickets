class Admin::FooterPagesController < ApplicationController
  before_action :set_footer_page, only: [:show, :edit, :update, :destroy]
  before_action :destroy_all_selected, only: [:index]
  helper_method :sort_column, :sort_direction
  before_action :require_admin
layout "admin"
  # GET /footer_pages
  # GET /footer_pages.json
  def index
    session[:search_params] = params[:footer_page] ? params[:footer_page] : nil

    session[:set_pager_number] = params[:set_pager_number] if params[:set_pager_number]

    if session[:set_pager_number].nil?
      session[:set_pager_number] = PER_PAGE
    end

    @o_all = FooterPage.
                  search(session[:search_params]).
                  order(sort_column + " " + sort_direction).
                  paginate(:per_page => session[:set_pager_number], :page => params[:page])

    @params_arr = { :name => { "type" => 'text' } }

    @o_single = controller_name.classify.constantize.new
  end

  # GET /footer_pages/1
  # GET /footer_pages/1.json
  def show
  end

  # GET /footer_pages/new
  def new
    @o_single = FooterPage.new
  end

  # GET /footer_pages/1/edit
  def edit
  end

  # POST /footer_pages
  # POST /footer_page_sessions
  # POST /footer_page_sessions.xml
  def create
    @o_single = FooterPage.new(footer_page_params)
    respond_to do |format|
      if @o_single.save
        format.html { redirect_to admin_footer_pages_url, notice: t("general.successfully_created") }
        format.json { head :no_content }
      else
        format.html { render action: 'new' }
        format.json { render json: @o_single.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /footer_pages/1
  # PATCH/PUT /footer_pages/1.json
  def update
    respond_to do |format|
      if @o_single.update(footer_page_params)
        format.html { redirect_to admin_footer_pages_url, notice: t("general.successfully_updated") }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @o_single.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /footer_pages/1
  # DELETE /footer_pages/1.json
  def destroy
    @o_single.destroy
    respond_to do |format|
      format.html { redirect_to admin_footer_pages_url, notice: t("general.successfully_destroyed") }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_footer_page
      @o_single = FooterPage.find(params[:id])
    end

    def destroy_all_selected
      if params[:rec]
        id_arrs = params[:rec].collect { |k, v| k }
        FooterPage.find(id_arrs).map(&:destroy)
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def footer_page_params
      params.require(:footer_page).permit!
    end

    def set_header_menu_active
      @footer_pages = "active"
    end

    def sort_column
      FooterPage.column_names.include?(params[:sort]) ? params[:sort] : "id"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
    end

end
