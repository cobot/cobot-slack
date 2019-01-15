class SpacesController < ApplicationController
  before_action :show_header, only: :index
  def index
    @spaces = current_user.spaces
  end

  def show
    @space = current_user.spaces.find(params[:id])
  end
end
