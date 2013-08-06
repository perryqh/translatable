require 'spec_helper'

describe "Translations" do

  before(:each) do
    Translation.send(:store).flushdb
  end

  describe "GET /" do
    before(:each) do
      visit translations_path
    end

    it "displays i18n locale filtering" do
      page.should have_content("Locales")
      page.should have_css("input#filter_by[type=text]")
    end

    it "displays create key form" do
      within(:css, 'form.new_translation') {
        page.should have_css("label[for=translation_key]")
        page.should have_css("label[for=translation_value]")
        page.should have_css("input[type=submit]")
      }
    end

    it "displays key/value grid" do
      page.should have_content("I18n Key")
      page.should have_content("Value")
    end
  end

  describe "update translation" do
    def update_value(value)
      within(:css, "tr[data-key=#{@key}]") {
        find('span.editable').click
        find('input[type=text]').set(value)
        find('button.save').click
      }
    end

    before(:each) do
      @key = "foo"
      @locale = 'en-US'
      Translation.new(:locale => @locale, :key => @key, :value => 'bar').save
      visit translations_path(:locale => @locale)
      page.should have_css("tr[data-key=#{@key}]")
    end

    it "updates the translation's value", :js => true do
      update_value('baz')
      visit translations_path(:locale => @locale)
      find("tbody tr[data-key=#{@key}] td.value span.editable").should have_text("baz")
    end

    it "replaces invalid encoded characters", :js => true do
      windows_encoded_value = "\x93quoted \x97 value\x94".force_encoding('cp1252')
      utf8_encoded_value = "\u201cquoted \u2014 value\u201d".force_encoding('utf-8')
      update_value(windows_encoded_value)
      visit translations_path(:locale => @locale)
      find("tbody tr[data-key=#{@key}] td.value span.editable").should have_text(utf8_encoded_value)
    end
  end

  describe "create translation" do
    def create_translation(key, value)
      visit translations_path
      fill_in 'Key', :with => key
      fill_in 'Value', :with => value
      click_button 'Create'
    end

    it "should create valid translation" do
      create_translation('trankey', 'tranvalue')

      find_field('Key').value.should be_blank
      find_field('Value').value.should be_blank

      find("tbody tr td.key").should have_text("trankey")
      find("tbody tr td.value span.editable").should have_text("tranvalue")
    end

    it "should replace invalid encoded characters" do
      windows_encoded_key = "\x91key\x92".force_encoding('cp1252')
      utf8_encoded_key = "\u2018key\u2019".force_encoding('utf-8')

      windows_encoded_value = "testing \x97 value".force_encoding('cp1252')
      utf8_encoded_value = "testing \u2014 value".force_encoding('utf-8')
      create_translation(windows_encoded_key, windows_encoded_value)

      find("tbody tr td.key").should have_text(utf8_encoded_key)
      find("tbody tr td.value span.editable").should have_text(utf8_encoded_value)
    end
  end
end
