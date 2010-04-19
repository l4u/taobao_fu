# Include hook code here
require "taobao_fu"

config_file = File.join(RAILS_ROOT, "config", "taobao.yml")
TaobaoFu.load(config_file)
