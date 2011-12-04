begin
  require "crack"
rescue LoadError
  puts "The Crack gem is not available.\nIf you ran this command from a git checkout " \
       "of Rails, please make sure crack is installed. \n "
  exit
end
# require "patron"
require "digest/md5"
require "yaml"
require "uri"
require "rest"

module TaobaoFu

  SANDBOX = 'http://gw.api.tbsandbox.com/router/rest?'
  PRODBOX = 'http://gw.api.taobao.com/router/rest?'
  USER_AGENT = 'why404-taobao_fu/1.0.0.beta5'
  REQUEST_TIMEOUT = 10
  API_VERSION = 2.0
  SIGN_ALGORITHM = 'md5'
  OUTPUT_FORMAT = 'json'
  
  class << self
    def load(config_file)
      @settings = YAML.load_file(config_file)
      @settings = @settings[Rails.env] if defined? Rails.env
      apply_settings
    end
    
    def apply_settings
      ENV['TAOBAO_API_KEY']    = @settings['app_key'].to_s
      ENV['TAOBAO_SECRET_KEY'] = @settings['secret_key']
      ENV['TAOBAOKE_PID']      = @settings['taobaoke_pid']
      @base_url                = @settings['is_sandbox'] ? SANDBOX : PRODBOX
      
      initialize_session if @settings['use_curl']
    end
    
    def initialize_session
      @sess = Patron::Session.new
      @sess.base_url = @base_url
      @sess.headers['User-Agent'] = USER_AGENT
      @sess.timeout = REQUEST_TIMEOUT
    end
    
    def switch_to(sandbox_or_prodbox)
      @base_url = sandbox_or_prodbox
      @sess.base_url = @base_url if @sess
    end
    
    def get(options = {})
      if @sess
        @response = @sess.get(generate_query_string(sorted_params(options))).body
      else
        @response = TaobaoFu::Rest.get(@base_url, generate_query_vars(sorted_params(options)))
      end
      parse_result @response
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
        :app_key     => @settings['app_key'],
        :format      => OUTPUT_FORMAT,
        :v           => API_VERSION,
        :sign_method => SIGN_ALGORITHM,
        :timestamp   => Time.now.strftime("%Y-%m-%d %H:%M:%S")
      }.merge!(options)
    end
    
    def generate_query_vars(params)
      params[:sign] = generate_sign(params.sort_by { |k,v| k.to_s }.flatten.join)
      params
    end
    
    def generate_query_string(params)
      params_array = params.sort_by { |k,v| k.to_s }
      sign_token = generate_sign(params_array.flatten.join)
      total_param = params_array.map { |key, value| key.to_s+"="+value.to_s } + ["sign=#{sign_token}"]
      URI.escape(total_param.join("&"))
    end
    
    def generate_sign(param_string)
      Digest::MD5.hexdigest(@settings['secret_key'] + param_string + @settings['secret_key']).upcase
    end
    
    def parse_result(data)
      Crack::JSON.parse(data)
    end
    
  end
  
end
