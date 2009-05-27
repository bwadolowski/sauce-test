class GooglePage < Selenium::Client::Driver

  def initialize()
    super( :host => "localhost",
           :port => 4444,
           :browser => '*chrome',
           :url => "http://www.google.com",
           :timeout_in_second => 60 )
  end


  def search_for(search_str)
    self.type "q", search_str
    self.click "btnG", :wait_for => :page
  end

  def query_str
    self.value("q")
  end

end
