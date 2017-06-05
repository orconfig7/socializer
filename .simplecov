# https://github.com/colszowka/simplecov#using-simplecov-for-centralized-config
SimpleCov.start "rails" do
  # see https://github.com/colszowka/simplecov/blob/master/lib/simplecov/defaults.rb

  # Add source groups
  add_group("Contracts")   { |src| src.filename.include?("/contract") }
  add_group "Decorators", "app/decorators"
  # add_group "Services",   %w(app/services)
  add_group("Services")   { |src| src.filename.include?("/services") }

  # Exclude these paths from analysis
  add_filter 'vendor'
  add_filter 'bundle'
end
