require 'digest/md5'
require 'uri'

# Taobao
module Taobao

  USER_AGENT = '404-taobao_fu/1.0b1'
  SANDBOX = 'http://gw.sandbox.taobao.com/router/rest?'
  PRODBOX = 'http://gw.api.taobao.com/router/rest?'
  
  class << self
    def load(config_file)
      if File.exist?(config_file)
        @settings = YAML.load_file(config_file)
        @settings = @settings[RAILS_ENV] if defined? RAILS_ENV
        apply(@settings)
      else
        Rails::logger.error "Error, missing #{config_file}. You must have #{config_file} to configure your app key that you can use the TOP SDK normally."
      end
    end
    
    def apply(settings)
      ENV['TAOBAO_API_KEY']    = settings['api_key'].to_s
      ENV['TAOBAO_SECRET_KEY'] = settings['secret_key']
      ENV['TAOBAOKE_PID']      = settings['taobaoke_pid']
      @config_options = settings
      initialize_connect if @config_options['enable_curl']
    end
    
    def initialize_connect
      @sess = Patron::Session.new
      @sess.timeout = @config_options['timeout']
      @sess.base_url = @config_options['real_time'] ? PRODBOX : SANDBOX
      @sess.headers['User-Agent'] = USER_AGENT
    end
    
    def get(options = {})
      if @sess
        @response = @sess.get(generate_query_string(sorted_params(options))).body
      else
        @response = RestClient.get(generate_url(sorted_params(options)))
      end
      parse_result(@response)
    end
    
    # http://toland.github.com/patron/
    def post(options = {})
    end
    
    def update(options = {})
    end
    
    def delete(options = {})
    end
    
    def sorted_params(options)
      {
        :app_key   => @config_options['api_key'],
        :format    => @config_options['format'],
        :v         => @config_options['version'],
        :timestamp => Time.now.to_s(:db)
      }.merge!(options).sort_by { |k,v| k.to_s }
    end
    
    def generate_url(params)
      (@config_options['real_time'] ? PRODBOX : SANDBOX) + generate_query_string(params)
    end
    
    def generate_query_string(params)
      total_param = params.map { |key, value| key.to_s+"="+value.to_s } + ["sign=#{generate_sign(params)}"]
      URI.escape(total_param.join("&"))
    end
    
    def generate_sign(params)
      Digest::MD5.hexdigest(@config_options['secret_key'] + params.to_s).upcase
    end
    
    def parse_result(result)
      case @config_options['format']
      when 'xml'
        Crack::XML.parse(result)['rsp'] || Crack::XML.parse(result)['error_rsp']
      when 'json'
        Crack::JSON.parse(result)['rsp'] || Crack::JSON.parse(result)['error_rsp']
      end
    end
    
  end
  
end