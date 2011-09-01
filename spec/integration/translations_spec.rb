describe "Translations" do
  describe "GET /" do
    it "displays i18n locale filtering" do
      visit translations_url
      page.should have_content("Locale")
      page.should have_content("Filter by")
    end

    it "displays key/value grid" do
      visit translations_url
      page.should have_content("I18n Key")
      page.should have_content("Value")
    end
  end
end
