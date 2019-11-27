class UserNoteController < ApplicationController
	def create
    @note = UserNote.new(user_note_params)

    if @note.save
      flash[:notice] = 'User note successfully added'
    else
      flash[:alert] = "Errors on user note #{@note.errors.messages}"
    end
    redirect_to edit_profile_path(@note.user_id)
	end

  protected

  def user_note_params
    params.require(:user_note).permit(:user_id, :note)
  end                       
end