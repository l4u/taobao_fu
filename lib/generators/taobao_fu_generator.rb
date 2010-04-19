class TaobaoFuGenerator < Rails::Generators::NamedBase
  
  def self.source_root
    @source_root ||= File.expand_path('../templates', __FILE__)
  end
  
  def create_config_file
    template 'taobao.yml', File.join('config', 'taobao.yml')
  end
  
end
