class ProductsController < ApplicationController
  def index

  end

  def new
    @product = Product.new
    if params[:product_images].present?
      @images = ImageTemp.where('id in ('+params[:product_images][0...-1]+')')
    end
    
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      imageIds = product_params[:product_images].split(/,/)
      imageIds.each do |id|
        @product.move_image(id, @product.id)
      end
      redirect_to products_path
    else
      if product_params[:product_images].present?
        @images = ImageTemp.where('id in ('+product_params[:product_images][0...-1]+')')
      end
      render :new
    end
  end

  private
  def product_params
    params.require(:product).permit(:name, :description, :product_images)
  end

end
