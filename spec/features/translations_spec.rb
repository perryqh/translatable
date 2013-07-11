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
    before(:each) do
      @key = "foo"
      @locale = 'en-US'
      Translation.new(:locale => @locale, :key => @key, :value => 'bar').save
      visit translations_path(:locale => @locale)
      page.should have_css("tr[data-key=#{@key}]")
    end

    it "updates the translation's value", :js => true do
      within(:css, "tr[data-key=#{@key}]") {
        find('span.editable').click
        find('input[type=text]').set('baz')
        find('button.save').click
      }
      visit translations_path(:locale => @locale)

      find("tbody tr[data-key=#{@key}] td.value span.editable").should have_text("baz")
    end
  end

  describe "create translation" do
    it "should create valid translation" do
      visit translations_path
      fill_in 'Key', :with => 'trankey'
      fill_in 'Value', :with => 'tranvalue'
      click_button 'Create'

      find_field('Key').value.should be_blank
      find_field('Value').value.should be_blank

      find("tbody tr td.key").should have_text("trankey")
      find("tbody tr td.value span.editable").should have_text("tranvalue")
    end
  end
end
