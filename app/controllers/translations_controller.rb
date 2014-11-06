class TranslationsController < ApplicationController
  respond_to :html, :json

  before_filter :tidy_params, :only => [:create, :update]
  before_filter :load_translation, :only => [:update, :destroy]

  def tidy_params
    tidy_hash(params)
  end

  def index
    @translation ||= Translation.new(:locale => locale)
  end

  def create
    @translation = Translation.new(params[:translation])

    if @translation.save
      flash[:notice] = "Successfully created I18N Translation."
      redirect_to translations_url
    else
      flash[:error] = "Error saving invalid translation."
      render :action => :index, :status => 500
    end
  end

  def update
    if @translation && @translation.save
      render :nothing => true, :status => 200
    else
      render :nothing => true, :status => 500
    end
  end

  def destroy
    @translation.destroy

    render :nothing => true, :status => 200
  end

  private
  helper_method :locale, :translations

  def translations
    Translation.find(:locale => locale, :filter_by => params[:filter_by])
  end

  def locale
    @locale ||= session[:locale] = (params[:locale] || session[:locale] || "en-US")
  end

  def load_translation
    @translation = Translation.find(:locale => locale, :key => params[:key])
    @translation.value = params[:value] if @translation && params[:value]
  end

  def tidy_hash(hash)
    hash.each_pair do |k,v|
      if v.respond_to?(:each_pair)
        hash[k] = tidy_hash(v)
      else
        hash[k] = ActiveSupport::Multibyte::Unicode.tidy_bytes(v)
      end
    end

    hash
  end
end
