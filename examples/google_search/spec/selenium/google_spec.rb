require File.dirname(__FILE__) + '/../spec_helper'

describe "Google Search" do

  before(:all) do
    @page = GooglePage.new
  end

  before(:each) do
    @page.start
  end

  append_after(:each) do
    @page.stop
  end

  it "can find Selenium" do
    @page.open "/"
    @page.title.should eql("Google")
    @page.search_for "Selenium"
    @page.query_str.should eql("Selenium")
    @page.title.should eql("Selenium - Google Search")
    @page.text?("seniumhq.org").should be_true
  end

  it "should return Sauce Labs website as top result" do
    @page.open "/"
    @page.title.should eql("Google")
    @page.search_for "Sauce Labs"
    @page.query_str.should eql("Sauce Labs")
    @page.title.should eql("Sauce Labs - Google Search")
    @page.text?("saucelabs.com").should be_true
  end



end
