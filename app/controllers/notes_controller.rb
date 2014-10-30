class NotesController < ApplicationController
  before_filter :authenticate_user!

  respond_to :json

  def reminders
    @notes = Notes.reminders.all

    render :json => @notes
  end

  def create
    @note = Note.create params[:note]
    @note.owner = current_user.email
    @note.save!

    render :json => @note
  end

  def update
    @note = Notes.find(params[:id])
    unless @note
      render :json => { error: "Note not found: #{params[:id]}" }, :status => 404 and return
    end
    @note.attributes = params[:note]

    @note.save!

    render :json => @note
  end

  def destroy
    @note = Notes.find(params[:id])
    unless @note
      render :json => { error: "Note not found: #{params[:id]}" }, :status => 404 and return
    end
    @note.destroy

    respond_with(status: 'Deleted')
  end

end