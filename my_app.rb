require 'sinatra'
require "sinatra/reloader" if development?
require "sinatra/activerecord"
require "sinatra/json"
require 'will_paginate'
require 'will_paginate/active_record'
require "will_paginate-bootstrap"
require 'sinatra-websocket'



set :server, 'thin'
set :sockets, []

# 创建一个存放静态文件的目录，主要存放css、js、font、image等文件
set :public_folder, File.dirname(__FILE__) + '/static'

set :database, {
  adapter:  'mysql2',
  host:     'localhost',
  username: 'root',
  password: 'root',
  database: 'mario3'
}

Time.zone = "Beijing"
ActiveRecord::Base.default_timezone = :local

configure :development do
  set :logging, Logger::DEBUG
  set :show_exceptions, :after_handler
end

enable :sessions
set :session_secret, "4659b8f4a27d22f631163db88639714833c6c61b30d2da85f35667615c912b6a1d691e11f73289c9bd5afae3e6213ddcd478aa30f9f454a1dd10e95c1837ba97"

WillPaginate.per_page = 15


require './model'
require './controller'
require './ajax'


if User.all.empty?
  user = User.new
  user.name = '管理员'
  user.account = 'mario'
  user.password = '123456'
  user.save
end
