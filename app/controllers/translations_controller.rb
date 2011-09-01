class TranslationsController < ApplicationController
  respond_to :html, :json

  def index

  end

  def create
    Translation.save(locale, params[:key], params[:value])

    render :nothing => true, :status => 200
  end

  def update
    Translation.save(locale, params[:key], params[:value])

    render :nothing => true, :status => 200
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
