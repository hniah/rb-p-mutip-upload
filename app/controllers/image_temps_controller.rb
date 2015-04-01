class ImageTempsController < ApplicationController

  def index
    @images = ImageTemp.all
  end

  def create
    @image = ImageTemp.new(image_params)

    if @image.save
      render json: { message: 'success', img_id: @image.id }, status: 200
    else
      render json: { error: @image.errors.full_messages.join(',')}, status: 400
    end
  end
  private
  def image_params
    params.require(:image_temp).permit(:picture)
  end

end
