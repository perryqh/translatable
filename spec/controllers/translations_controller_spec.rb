require 'spec_helper'

describe TranslationsController do
  describe "locale helper method" do
    it "should use default en if not speicified in session or params" do
      @controller.send(:locale).should == 'en-US'
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
      Translation.should_receive(:find).with(:locale => 'en-US').and_return translations

      @controller.send(:translations).should == translations
    end
  end

  describe "get index" do
    it "should render index template" do
      get :index
      response.should render_template(:index)
    end
  end

  describe "put update" do
    before(:each) do
      Translation.send(:store).flushdb
      Translation.save('en-US', 'error', 'big error!')
      Translation.locale_value('en-US', 'error').should == 'big error!'
    end

    it "should update key" do
      xhr :put, :update, :id => 'yada', :key => 'error', :value => 'even bigger'

      response.should be_success
      Translation.locale_value('en-US', 'error').should == 'even bigger'
    end
  end
end
