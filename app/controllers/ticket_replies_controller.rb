class TicketRepliesController < ApplicationController

  before_action :require_user
  
  # GET /ticket_replies/1/edit
  def edit
    @ticket_reply = TicketReply.find(params[:id])
    respond_to do |format|
      format.html
      format.js
    end    
  end

  # PATCH/PUT /ticket_replies/1
  # PATCH/PUT /ticket_replies/1.json
  def update
    @ticket_reply = TicketReply.find(params[:id])
    @ticket_reply.update(ticket_reply_params)
    #ticket log
    TicketLog.update_reply_post_log(@ticket_reply, current_user)    
  end

  private
  
    def ticket_reply_params
      params.require(:ticket_reply).permit!
    end
    
end
