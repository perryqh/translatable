class TranslationsController < ApplicationController
  respond_to :html, :json

  def index
    @translation ||= Translation.new(:locale => locale)
  end

  def create
    @translation = Translation.new(params[:translation])

    if @translation.save
      flash[:notice] = "Successfully created I18N Translation."
      redirect_to translations_url
    else
      render :action => :index
    end
  end

  def update
    translation = Translation.find(:locale => locale, :key => params[:key])

    translation.value = params[:value]

    if translation.save
      render :nothing => true, :status => 200
    else
      render :nothing => true, :status => 500
    end
  end

  private
  helper_method :locale, :translations

  def translations
    Translation.find(:locale => locale, :filter_by => params[:filter_by])
  end

  def locale
    @locale ||= session[:locale] = (params[:locale] || session[:locale] || "en-US")
  end
end
