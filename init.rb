# Include hook code here

require 'taobao' 

config_file = "#{RAILS_ROOT}/config/taobao.yml"
Taobao.load(config_file)
