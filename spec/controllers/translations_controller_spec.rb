require 'spec_helper'

describe TranslationsController do
  describe "locale helper method" do
    it "should use default en if not speicified in session or params" do
      @controller.send(:locale).should == 'en'
    end

    it "should use session locale if it exists" do
      session[:locale] = 'jo-locale'
      @controller.send(:locale).should == 'jo-locale'
    end

    it "should use params locale as highest priority" do
      session[:locale] = 'jo-locale'
      get :index, :locale => 'params-locale'
      @controller.send(:locale).should == 'params-locale'
    end
  end

  describe "translations" do
    it "should find all of the translations by locale" do
      translations = [Translation.new]
      Translation.should_receive(:find).with(:locale => 'en').and_return translations

      @controller.send(:translations).should == translations
    end
  end

  describe "get index" do
    it "should render index template" do
      get :index
      response.should render_template(:index)
    end
  end
end
