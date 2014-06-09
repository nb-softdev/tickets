class Admin::LanguagesController < ApplicationController
  before_action :set_language, only: [:show, :edit, :update, :destroy]
  before_action :destroy_all_selected, only: [:index]
  helper_method :sort_column, :sort_direction
  before_action :require_admin
  before_action :create_default_language, only: [:index]
layout "admin"
  # GET /languages
  # GET /languages.json
  def index
    session[:search_params] = params[:language] ? params[:language] : nil

    session[:set_pager_number] = params[:set_pager_number] if params[:set_pager_number]

    if session[:set_pager_number].nil?
      session[:set_pager_number] = PER_PAGE
    end

    @o_all = Language.
                  search(session[:search_params]).
                  order(sort_column + " " + sort_direction).
                  paginate(:per_page => session[:set_pager_number], :page => params[:page])

    @params_arr = { :name => { "type" => 'text' }, :code => { "type" => 'text' } }

    @o_single = controller_name.classify.constantize.new
  end

  # GET /languages/1
  # GET /languages/1.json
  def show
  end

  # GET /languages/new
  def new
    @o_single = Language.new
  end

  # GET /languages/1/edit
  def edit
  end

  # POST /languages
  # POST /language_sessions
  # POST /language_sessions.xml
  def create
    @o_single = Language.new(language_params)
    respond_to do |format|
      if @o_single.save
        create_locale_file
        format.html { redirect_to admin_languages_url, notice: t("general.successfully_created") }
        format.json { head :no_content }
      else
        format.html { render action: 'new' }
        format.json { render json: @o_single.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /languages/1
  # PATCH/PUT /languages/1.json
  def update
    respond_to do |format|
      if @o_single.update(language_params)
        update_locale_file
        format.html { redirect_to admin_languages_url, notice: t("general.successfully_updated") }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @o_single.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /languages/1
  # DELETE /languages/1.json
  def destroy
    delete_locale_file
    @o_single.destroy
    respond_to do |format|
      format.html { redirect_to admin_languages_url, notice: t("general.successfully_destroyed") }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_language
      @o_single = Language.find(params[:id])
    end

    def destroy_all_selected
      if params[:rec]
        id_arrs = params[:rec].collect { |k, v| k }
        Language.find(id_arrs).map(&:destroy)
      end
    end

    def create_locale_file
      source_locale_file = File.read(Rails.root.join("config", "locales", "en.yml"))
      source_locale_file = source_locale_file.sub("en:", "#{@o_single.code}:")
      new_locale_file = Rails.root.join("config", "locales", "#{@o_single.code}.yml")
      target = File.open(new_locale_file, 'w') {|f| f.write(source_locale_file) }
    end

    def update_locale_file
      new_locale_file = Rails.root.join("config", "locales", "#{@o_single.code}.yml")
      target = File.open(new_locale_file, 'w') {|f| f.write(@o_single.content) }
    end

    def delete_locale_file
      new_locale_file = Rails.root.join("config", "locales", "#{@o_single.code}.yml")
      if File.exist?(new_locale_file)
        File.delete(new_locale_file)
      end
    end

    def create_default_language
      lang = Language.find_by(:code => "en")
      if lang.nil?
        Language.create(:name => "English", :code => "en", :is_default => true)
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def language_params
      params.require(:language).permit!
    end

    def set_header_menu_active
      @languages = "active"
    end

    def sort_column
      Language.column_names.include?(params[:sort]) ? params[:sort] : "id"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
    end

end
