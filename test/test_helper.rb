ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require "minitest/reporters"
require 'scrutinizer/ocular'
require 'capybara-screenshot/minitest'
require 'simplecov'
SimpleCov.start do
  add_filter "/test/"
end
Scrutinizer::Ocular.watch! # scrutinizer coverage Setup
Minitest::Reporters.use! # minitest Setup
Capybara::Screenshot.autosave_on_failure = false
Capybara::Screenshot.webkit_options = { width: 1024, height: 768 }

class ActiveSupport::TestCase
  fixtures :all   # Setup test/fixtures/*.yml  in alphabetical order.
  include Capybara::DSL
  include Warden::Test::Helpers
  Warden.test_mode!
end
