About TaobaoFu
--------------

**TaobaoFu** is a Rails plugin (supports Rails 3.0.0 or above) as an unofficial Ruby SDK for the Taobao Open Platform(http://open.taobao.com/).


### Compatibility

TaobaoFu is developed against Ruby 1.8.6, 1.8.7, 1.9.1, 1.9.2


### Installation

Get the TaobaoFu plugin from github.com: 

    rails plugin install git://github.com/why404/taobao_fu.git

For Rails applications add the gem dependencies to your Gemfile: 

    gem "crack"     # Required
    gem "patron"    # Optional, if you set the :use_curl option is true in config/taobao.yml 

Setup of access the TOP API is handled by using automatic configuration with a config/taobao.yml. You can generate a taobao.yml via the following command: 

    rails generate taobao_fu config

An example configuration is as follows, with the default values showing: 
config/taobao.yml: 

    defaults: &defaults
      app_key:          # YOUR_APP_KEY
      secret_key:       # YOUR_APP_SECRET_TOKEN
      taobaoke_pid:     # YOUR_TAOBAOKE_PID
      taobaoke_nick:    # YOUR_TAOBAOKE_NICKNAME

    development:
      <<: *defaults
      is_sandbox: false # If true, it will work under the sandbox environment(tbsandbox.com, not taobao.com).
      use_curl: false   # If true, it will use gem "patron" as the REST client.

    test:
      <<: *defaults
      is_sandbox: ture
      use_curl: false

    production:
      <<: *defaults
      is_sandbox: false
      use_curl: true


### Example

Here is an example shows you how to get some information of a commodity from taobao.com by using the TaobaoFu.get method.

    > cd your_rails_app
    > rails console
    > TaobaoFu.get(:method => 'taobao.item.get', 
                   :nick   => 'simul官方旗舰店', 
                   :iid    => '3b54462a34e2ed84c330dc3e5fb4a94f', 
                   :fields => 'title, price')

There are four methods mapping HTTP verbs(GET/POST/PUT/DELETE).

    TaobaoFu.get    #(Available)
    TaobaoFu.post
    TaobaoFu.update
    TaobaoFu.delete

There is also an additional method is using for switching between sandbox and production environment of TOP. For instance:

    TaobaoFu.switch_to(TaobaoFu::SANDBOX) # switching to sandbox(tbsandbox.com)
    TaobaoFu.switch_to(TaobaoFu::PRODBOX) # back to production environment(taobao.com)


### License

Copyright (c) 2010 why404(why404#gmail), released under the MIT license.
