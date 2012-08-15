require 'autowatchr'

Autowatchr.new(self) do |config|
  config.failing_only = true
end