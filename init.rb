require "taobao_fu"

config_file = File.join(RAILS_ROOT, "config", "taobao.yml")
TaobaoFu.load(config_file) if FileTest::exists?(config_file)
