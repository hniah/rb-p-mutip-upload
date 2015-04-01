class ImagesController < ApplicationController

  def index

  	@images = Image.all
    @image = Image.new
    @image.perform(1)

  end

  def create
  	@image = Image.new(image_params)

    if @image.save
      render json: { message: "success", fileID: @image.id }, status: 200
    else
      render json: { error: @image.errors.full_messages.join(',')}, status: 400
    end     
  end
  private
  def image_params
    params.require(:image).permit(:avatar)
  end


end
