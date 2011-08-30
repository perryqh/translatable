class TranslationsController < ApplicationController
  def index

  end

  private
  helper_method :locale, :translations

  def translations
    Translation.find(:locale => locale)
  end

  def locale
    @locale ||= session[:locale] = (params[:locale] || session[:locale] || "en")
  end
end
