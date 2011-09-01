require 'spec_helper'

describe Translation do
  before(:each) do
    Translation.send(:store).flushdb
  end

  describe "formatted key" do
    it "should properly format key with locale" do
      Translation.send(:formatted_key, "en-US", "taco").should == 'en-US.taco'
    end
  end

  describe "locales" do
    before(:each) do
      Translation.save('en-US', 'jimmy', 'joe')
      Translation.save('en-US', 'jimmy', 'jack')
      Translation.save('xx-YY', 'jimmy', 'joe')
      Translation.save('xx-YY', 'timmy', 'joe')
      Translation.save('ss-SS', 'jimmy', 'joe')
      Translation.save('aa-AA', 'jimmy', 'joe')
      Translation.save('en-US', 'jimmy', 'joe')
    end

    specify { Translation.locales.should == ['aa-AA', 'en-US', 'ss-SS', 'xx-YY']}
  end

  describe "create and read" do
    it "should create and read translation by locale" do
      Translation.save('en-US', 'foo', 'bar')
      Translation.send(:store)['en-US.foo'].should == 'bar'
      Translation.locale_value('en-US', 'foo').should == 'bar'
      Translation.locale_value('es-ES', 'foo').should be_nil
    end

    it "should include all key values" do
      Translation.save('en-US', 'jimmy', 'joe')
      Translation.save('en-US', 'timmy', 'toe')

      Translation.available_keys('en-US').include?('jimmy').should be_true
      Translation.available_keys('en-US').include?('timmy').should be_true
      Translation.available_keys('en-US').include?('not exists').should be_false

      Translation.find(:locale => 'en-US').first.locale.should == 'en-US'
      Translation.find(:locale =>'en-US').first.key.should == 'jimmy'
      Translation.find(:locale =>'en-US').first.value.should == 'joe'

      Translation.find(:locale =>'en-US').last.locale.should == 'en-US'
      Translation.find(:locale =>'en-US').last.key.should == 'timmy'
      Translation.find(:locale =>'en-US').last.value.should == 'toe'
    end
  end

  describe "reload!" do
    it "should flush and load the translations" do
      Translation.available_keys('en-US').should be_empty
      Translation.save('en-US', 'timmy', 'joe')
      Translation.available_keys('en-US').count.should == 1

      Translation.reload!
      Translation.available_keys('en-US').should be_empty
    end
  end
end
