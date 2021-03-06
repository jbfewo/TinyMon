class LoggedInMenuViewController < UITableViewController
  stylesheet :logged_in_menu_sheet
  
  ITEMS = [{
    rows: [{
      title: lambda { User.current.full_name },
      key: :user
    }, {
      title: lambda { Account.current.name },
      key: :account
    }]
  }, {
    title: I18n.t("menu.monitoring"),
    rows: [{
      title: I18n.t("menu.activity"),
      key: :activity
    }, {
      title: I18n.t("menu.sites"),
      key: :sites
    }, {
      title: I18n.t("menu.health_checks"),
      key: :health_checks
    }]
  }, {
    title: I18n.t("menu.account"),
    rows: [{
      title: I18n.t("menu.switch_account"),
      key: :accounts
    }, {
      title: I18n.t("menu.users"),
      key: :users
    }]
  }, {
    title: I18n.t("menu.general"),
    rows: [{
      title: I18n.t("menu.log_out"),
      key: :logout
    }]
  }]
  
  def init
    super
    layout tableView, :table
    self
  end
  
  def numberOfSectionsInTableView(tableView)
    ITEMS.size
  end

  def tableView(tableView, numberOfRowsInSection:section)
    ITEMS[section][:rows].size
  end

  def tableView(tableView, titleForHeaderInSection:section)
    ITEMS[section][:title]
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    fresh_cell.tap do |cell|
      text = ITEMS[indexPath.section][:rows][indexPath.row][:title]
      text = text.call if text.respond_to?(:call)
      cell.textLabel.text = text
    end
  end
  
  def tableView(tableView, heightForHeaderInSection:section)
    section == 0 ? 0 : 30
  end
  
  def tableView(tableView, viewForHeaderInSection:section)
    view = UIView.alloc.initWithFrame([[0, 0], [320, 30]])
    layout(view, :header) do
      subview(UIView, :bottom_line)
      label = subview(UILabel, :header_label)
      label.text = tableView(tableView, titleForHeaderInSection:section)
    end
    view
  end
  
  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    selected = ITEMS[indexPath.section][:rows][indexPath.row][:key]
    
    viewController = case selected
    when :user
      CurrentUserViewController.alloc.init
    when :activity
      RecentCheckRunsViewController.alloc.init
    when :sites
      SitesViewController.alloc.init
    when :health_checks
      AllHealthChecksViewController.alloc.init
    when :accounts
      AccountsViewController.alloc.init
    when :users
      UserAccountsViewController.alloc.init
    when :logout
      logout
      return
    else
      SitesViewController.alloc.init
    end
    
    self.viewDeckController.centerController = LoggedInNavigationController.alloc.initWithRootViewController(viewController)
    
    tableView.deselectRowAtIndexPath(indexPath, animated:true)
    self.viewDeckController.toggleLeftView
  end
  
  def logout
    MotionResource::Base.default_url_options = nil
    UIApplication.sharedApplication.keyWindow.rootViewController = MonitorNavigationController.alloc.init
  end

private
  def fresh_cell
    tableView.dequeueReusableCellWithIdentifier('Cell') ||
    UITableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier:'Cell').tap do |cell|
      layout cell, :cell do
        subview(UIView, :top_line)
        subview(UIView, :bottom_line)
      end
      
      cell.setSelectedBackgroundView(layout(UIView.alloc.init, :selected))
    end
  end
end
