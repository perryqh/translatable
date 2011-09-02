class TranslationsController < ApplicationController
  respond_to :html, :json

  def index

  end

  def create
    translation = Translation.new(:locale => locale, :key => params[:key], :value => params[:value])

    if translation.save
      render :nothing => true, :status => 200
    else
      render :nothing => true, :status => 500
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
    Translation.find(:locale => locale)
  end

  def locale
    @locale ||= session[:locale] = (params[:locale] || session[:locale] || "en-US")
  end
end
