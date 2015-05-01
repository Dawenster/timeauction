class RolesController < ApplicationController
  def save_details
    respond_to do |format|
      role = Role.find(params[:role_id])
      if role.user == current_user
        role.update_attributes(
          :title => params[:title],
          :description => params[:description]
        )
        format.json { render :json => { :data => role.to_json } }
      else
        format.json { render :json => { :status => 500, :data => "Woah, whatcha tryin' to pull?" } }
      end
    end
  end
end