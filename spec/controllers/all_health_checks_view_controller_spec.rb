describe AllHealthChecksViewController do
  extend WebStub::SpecHelpers
  extend MotionResource::SpecHelpers
  
  before do
    Account.current = Account.instantiate(:id => 5, :role => 'user')
    User.current = User.instantiate(:id => 1, :role => 'user')
    
    stub_request(:get, "http://mon.tinymon.org/en/health_checks.json").to_return(json: { :health_checks => [{ :id => 10, :status => 'success', :enabled => true, :name => 'Test', :site => { :id => 10, :name => 'Test-Site' } }, { :id => 15, :status => 'failure', :enabled => true, :name => 'Foo', :site => { :id => 10, :name => 'Test-Site' } }] })
  end
  
  tests AllHealthChecksViewController
  
  it "should have speaking title" do
    wait 0.2 do
      controller.title.should == "All Health Checks"
    end
  end
  
  it "should have no plus button" do
    wait 0.2 do
      controller.navigationItem.rightBarButtonItem.should.be.nil
    end
  end
  
  it "should show all health checks" do
    wait 0.2 do
      controller.health_checks.size.should == 2
      controller.tableView.numberOfRowsInSection(0).should == 2
    end
  end
  
  it "should show health check names" do
    view("Test").should.not.be.nil
    view("Foo").should.not.be.nil
  end
  
  it "should show status icons" do
    view("success.png").should.not.be.nil
    view("failure.png").should.not.be.nil
  end
  
  it "should refresh on pull down" do
    wait 0.5 do
      reset_stubs
      stub_request(:get, "http://mon.tinymon.org/en/health_checks.json").to_return(json: { :health_checks => [{ :id => 10, :status => 'success', :name => 'Test', :enabled => false, :site => { :id => 10, :name => 'Test-Site' } }] })
      drag controller.tableView, :to => :bottom, :duration => 1
      
      view("offline.png").should.not.be.nil
      controller.health_checks.size.should == 1
      controller.tableView.numberOfRowsInSection(0).should == 1
    end
  end
  
  it "should filter health checks" do
    tap controller.search_bar
    controller.search_bar.text = 'Test'
    wait 0.2 do
      controller.filtered_health_checks.size.should == 1
      controller.search_bar.resignFirstResponder
    end
  end
end
