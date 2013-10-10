# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/ios'
require 'bundler'

if ARGV.join(' ') =~ /spec/
  Bundler.require :default, :spec
else
  Bundler.require
end

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.identifier = "org.tinymon.TinyMon"
  app.name = 'TinyMon'
  app.files = (app.files - Dir.glob('./app/**/*.rb')) + Dir.glob("./lib/**/*.rb") + Dir.glob("./config/**/*.rb") + Dir.glob("./app/**/*.rb")
  app.vendor_project('vendor/Reachability', :static)
  app.vendor_project('vendor/iOSPlot', :static)
  app.vendor_project('vendor/TVNavigationController', :static)
  app.vendor_project('vendor/HJCache', :static)
  
  app.detect_dependencies = false
  app.files_dependencies 'app/controllers/all_health_checks_view_controller.rb' => 'app/controllers/health_checks_view_controller.rb'
  app.files_dependencies 'app/controllers/check_run_log_entry_view_controller.rb' => 'app/controllers/html_view_controller.rb'
  app.files_dependencies 'app/controllers/current_user_view_controller.rb' => 'app/controllers/user_view_controller.rb'
  
  app.pods do
    pod 'SVProgressHUD', '0.8'
    pod 'ViewDeck', '1.4.2'
    pod 'TestFlightSDK', '1.1'
    pod 'NSData+MD5Digest'
  end
  
  app.development do
    app.testflight do
      app.testflight.api_token = 'apitoken'
      app.testflight.team_token = 'teamtoken'
    end
  end

  app.frameworks += ["MapKit"]
end

task :resources do
  icons = %w(success failure offline)
  icons += (0..5).to_a.collect { |i| "weather-#{i}" }
  
  icons.each do |icon|
    sh "convert -resize 88x88 app/assets/#{icon}.png resources/#{icon}@2x.png"
    sh "convert -resize 44x44 app/assets/#{icon}.png resources/#{icon}.png"
  end
end
