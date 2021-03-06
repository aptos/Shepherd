class NotesController < ApplicationController
  before_filter :authenticate_user!

  respond_to :json

  def reminders
    @notes = Note.reminders.all

    render :json => @notes
  end

  def create
    @note = Note.create params[:note]
    @note.owner = current_user.email
    @note.save!

    if @note.due_date == Date.today
      msg = "Msg for #{@note.owner} from Shepherd:\n"
      msg += "<a href='https://taskit-crm.herokuapp.com/users/#{@note.uid}'>#{@note.name} - #{@note.company}</a>\n"
      msg += @note.details
      slack.ping msg, channel: '#app_important'
    end

    render :json => @note
  end

  def update
    @note = Note.find(params[:id])
    unless @note
      render :json => { error: "Note not found: #{params[:id]}" }, :status => 404 and return
    end
    @note.attributes = params[:note]

    @note.save!

    render :json => @note
  end

  def destroy
    @note = Note.find(params[:id])
    unless @note
      render :json => { error: "Note not found: #{params[:id]}" }, :status => 404 and return
    end
    @note.destroy

    render :json => { ok: true, message: 'note permanently removed'}
  end

end