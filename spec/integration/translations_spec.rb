describe "Translations" do
  describe "GET /" do
    it "displays i18n locale filtering" do
      visit translations_url
      page.should have_content("Locales")
    end

    it "displays key/value grid" do
      visit translations_url
      page.should have_content("I18n Key")
      page.should have_content("Value")
    end
  end

  describe "create translation" do
    it "should create valid translation" do
      visit translations_url
      fill_in 'Key', :with => 'trankey'
      fill_in 'Value', :with => 'tranvalue'
      click_button 'Create'

      page.should have_content 'trankey'
      page.should have_content 'tranvalue'
    end
  end
end
