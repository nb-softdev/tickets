class TicketLogsController < ApplicationController
  before_action :set_ticket, only: [:index]
  before_action :require_staff_or_company_admin
  
  # GET /ticket_logs
  # GET /ticket_logs.json
  def index
    @o_all = @ticket.ticket_logs
  end


  private

  def set_ticket
    @ticket = current_company.tickets.find_by_id(params[:ticket_id])
    unless @ticket
      redirect_to company_front_path(current_company.sub_domain)
    end
  end  

end
