describe "Translations" do
  before(:each) do
    Translation.send(:store).flushdb
  end

  describe "GET /" do
    before(:each) do
      visit translations_url
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

  describe "create translation" do
    it "should create valid translation" do
      visit translations_url
      fill_in 'Key', :with => 'trankey'
      fill_in 'Value', :with => 'tranvalue'
      click_button 'Create'

      find_field('Key').value.should be_blank
      find_field('Value').value.should be_blank

      within(:css, 'tbody tr') {
        find('td.key').text.should == 'trankey'
        find('td.value span.editable').text.should == 'tranvalue'
      }
    end
  end
end
