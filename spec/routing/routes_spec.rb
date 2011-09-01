require 'spec_helper'

describe 'Routes' do
  context "TranslationsController" do
    it "should route to index" do
      {:get => '/'}.should route_to('translations#index')
      {:get => '/translations'}.should route_to('translations#index')
    end

    it "shiuld route to update" do
      {:put => '/translations/x'}.should route_to('translations#update', :id => 'x')
    end
  end
end
