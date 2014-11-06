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
      Translation.should_receive(:find).with(:locale => 'en-US', :filter_by => nil).and_return translations

      @controller.send(:translations).should == translations
    end
  end

  describe "get index" do
    it "should render index template" do
      get :index
      response.should render_template(:index)
    end
  end

  describe "post create" do
    subject(:create) do
      xhr :post, :create, translation: {key: key, value: value, locale: locale}
    end

    before(:each) { Translation.send(:store).flushdb }

    let(:key) { 'create.key' }
    let(:value) { 'value for you' }
    let(:locale) { 'ck-KK' }

    context 'when translation is valid ASCII' do
      it 'should redirect to the translations index' do
        create
        response.should redirect_to(translations_url)
      end

      it 'should create the translation' do
        create
        expect(Translation.locale_value(locale, key)).to eq(value)
      end
    end

    context 'when translation key is invalid' do
      let(:key) { '' }

      it 'should return 500' do
        create
        expect(response.status).to eq(500)
      end

      it 'should render the translation index' do
        create
        expect(response).to render_template(:index)
      end

      it 'should display an error message' do
        create
        expect(flash[:error]).to eq('Error saving invalid translation.')
      end

      it 'should not save the translation' do
        create
        expect(Translation.locale_value(locale, key)).to_not be
      end
    end

    context 'when translation key is not UTF-8' do
      let(:key) { "\x91key\x92".force_encoding('cp1252') }

      it 'should redirect to the translations index' do
        create
        response.should redirect_to(translations_url)
      end

      it 'should create the translation with a UTF-8 string as the key' do
        create
        utf8_encoded_key = "\u2018key\u2019".force_encoding('utf-8')
        expect(Translation.locale_value(locale, utf8_encoded_key)).to eq(value)
      end
    end

    context 'when translation value is not UTF-8' do
      let(:value) { "testing \x97 value".force_encoding('cp1252') }

      it 'should redirect to the translations index' do
        create
        response.should redirect_to(translations_url)
      end

      it 'should create the translation with a UTF-8 string as the value' do
        create
        utf8_encoded_value = "testing \u2014 value".force_encoding('utf-8')
        expect(Translation.locale_value(locale, key)).to eq(utf8_encoded_value)
      end
    end
  end

  describe "delete destroy" do
    before(:each) do
      Translation.send(:store).flushdb
      Translation.new(:locale => 'en-US', :key => 'todelete', :value => 'useless!').save
    end

    it "should destroy translation" do
      xhr :delete, :destroy, :id => 'foo', :locale => 'en-US', :key => 'todelete'

      response.status.should == 200
      Translation.find(:locale => 'en-US', :key => 'todelete').should be_nil
    end
  end

  describe "put update" do
    subject(:update) do
      xhr :put, :update, id: translation_id, key: key, value: value
    end

    before(:each) do
      Translation.send(:store).flushdb
      Translation.new(locale: locale, key: key, value: orig_value).save
    end

    let(:locale) { 'en-US' }
    let(:translation_id) { 'yada' }
    let(:key) { 'error' }
    let(:orig_value) { 'big error!' }

    context 'when value is valid ASCII' do
      let(:value) { 'even bigger' }

      it 'should respond successfully' do
        update
        expect(response).to be_success
      end

      it 'should update the stored translation value' do
        update
        expect(Translation.locale_value(locale, key)).to eq(value)
      end
    end

    context 'when translation does not exist' do
      let(:translation_id) { 'xx' }
      let(:key) { '' }
      let(:value) { 'should never happen' }

      it 'should return 500' do
        update
        expect(response.status).to eq(500)
      end

      it 'should not save translation' do
        update
        expect(Translation.locale_value(locale, key)).to be_nil
      end
    end

    context 'when new value is not UTF-8' do
      let(:value) { "testing \x97 value".force_encoding('binary') }

      it 'should respond successfully' do
        update
        expect(response).to be_success
      end

      it 'should update the stored translation value' do
        utf8_encoded_value = "testing \u2014 value".force_encoding('utf-8')
        update
        expect(Translation.locale_value(locale, key)).to eq(utf8_encoded_value)
      end
    end
  end
end
