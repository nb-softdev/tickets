class Admin::EmailTemplatesController < ApplicationController
  before_action :set_email_template, only: [:show, :edit, :update, :destroy]
  before_action :destroy_all_selected, only: [:index]
  helper_method :sort_column, :sort_direction
  before_action :require_admin
layout "admin"
  # GET /email_templates
  # GET /email_templates.json
  def index
    session[:search_params] = params[:email_template] ? params[:email_template] : nil

    session[:set_pager_number] = params[:set_pager_number] if params[:set_pager_number]

    if session[:set_pager_number].nil?
      session[:set_pager_number] = PER_PAGE
    end

    @o_all = EmailTemplate.
                  search(session[:search_params]).
                  order(sort_column + " " + sort_direction).
                  paginate(:per_page => session[:set_pager_number], :page => params[:page])

    @params_arr = { :email_type => { "type" => 'text' }, :subject => { "type" => 'text' } }

    @o_single = controller_name.classify.constantize.new
  end

  # GET /email_templates/1
  # GET /email_templates/1.json
  def show
  end

  # GET /email_templates/new
  def new
    @o_single = EmailTemplate.new
  end

  # GET /email_templates/1/edit
  def edit
    @file_content = get_email_template_file(@o_single)
  end

  # POST /email_templates
  # POST /email_template_sessions
  # POST /email_template_sessions.xml
  def create
    @o_single = EmailTemplate.new(email_template_params)
    respond_to do |format|
      if @o_single.save
        format.html { redirect_to admin_email_templates_url, notice: t("general.successfully_created") }
        format.json { head :no_content }
      else
        format.html { render action: 'new' }
        format.json { render json: @o_single.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /email_templates/1
  # PATCH/PUT /email_templates/1.json
  def update
    respond_to do |format|
      if @o_single.update(email_template_params)
        update_email_template_file(@o_single)
        format.html { redirect_to admin_email_templates_url, notice: t("general.successfully_updated") }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @o_single.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /email_templates/1
  # DELETE /email_templates/1.json
  def destroy
    @o_single.destroy
    respond_to do |format|
      format.html { redirect_to email_templates_url, notice: t("general.successfully_destroyed") }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_email_template
      @o_single = EmailTemplate.find(params[:id])
    end

    def destroy_all_selected
      if params[:rec]
        id_arrs = params[:rec].collect { |k, v| k }
        EmailTemplate.find(id_arrs).map(&:destroy)
      end
    end

    def update_email_template_file(email_template)
      case email_template.email_type
      when "registration_email"
        new_email_template_file = Rails.root.join("app", "views", "user_mailer", "registration_confirmation.html.erb")
      when "forgot_password"
        new_email_template_file = Rails.root.join("app", "views", "user_mailer", "forgot_password_confirmation.html.erb")
      end

      target = File.open(new_email_template_file, 'w') {|f| f.write(email_template.content) }
    end

    def get_email_template_file(email_template)
      case email_template.email_type
      when "registration_email"
        new_email_template_file = Rails.root.join("app", "views", "user_mailer", "registration_confirmation.html.erb")
      when "forgot_password"
        new_email_template_file = Rails.root.join("app", "views", "user_mailer", "forgot_password_confirmation.html.erb")
      end

      target = File.read(new_email_template_file)
      return target
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def email_template_params
      params.require(:email_template).permit!
    end

    def set_header_menu_active
      @email_templates = "active"
    end

    def sort_column
      EmailTemplate.column_names.include?(params[:sort]) ? params[:sort] : "id"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
    end

end
