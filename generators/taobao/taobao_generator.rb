class TaobaoGenerator < Rails::Generator::Base
  
  def manifest
    record do |m|
      m.directory 'config'
      m.file 'taobao.yml', 'config/taobao.yml'
    end
  end
 
end

