require 'sinatra'
require "sinatra/reloader" if development?
require "sinatra/activerecord"
require "sinatra/json"
require 'will_paginate'
require 'will_paginate/active_record'
require "will_paginate-bootstrap"


# 创建一个存放静态文件的目录，主要存放css、js、font、image等文件
set :public_folder, File.dirname(__FILE__) + '/static'

set :database, {
  adapter:  'mysql2',
  host:     'localhost',
  username: 'root',
  password: 'root',
  database: 'mario3'
}

configure :development do
  set :logging, Logger::DEBUG
  set :show_exceptions, :after_handler
end

enable :sessions
set :session_secret, "4659b8f4a27d22f631163db88639714833c6c61b30d2da85f35667615c912b6a1d691e11f73289c9bd5afae3e6213ddcd478aa30f9f454a1dd10e95c1837ba97"

WillPaginate.per_page = 15

# -----------------------------------------------
# models
# -----------------------------------------------

class User < ActiveRecord::Base
end

class Pipeline < ActiveRecord::Base
  has_many :nodes, -> { order('seq') }, class_name: "PipelineNode", dependent: :destroy
end

class PipelineNode < ActiveRecord::Base
  belongs_to :pipeline
end

# class OriPipeline < ActiveRecord::Base
#   self.table_name = "pipe_line"
#
# end
#
# class OriPipelineNode < ActiveRecord::Base
#   self.table_name = "pipe_line_node"
# end


if User.all.empty?
  user = User.new
  user.name = '管理员'
  user.account = 'mario'
  user.password = '123456'
  user.save
end


# OriPipeline.all.each do |opl|
#
#   pl = Pipeline.new
#   pl.name = opl.name
#   pl.no = opl.no
#   pl.start_position = opl.start_position
#   pl.end_position = opl.end_position
#   pl.remark = opl.remarks
#   pl.save
#
#
#   OriPipelineNode.where(pipe_line_id: opl.id).each do |opln|
#     pln = PipelineNode.new
#     pln.pipeline = pl
#     pln.lng = opln.lon
#     pln.lat = opln.lat
#     pln.no = opln.no
#     pln.distance = opln.gyjl
#     pln.remark = opln.remarks
#     pln.seq = opln.sort
#     pln.save
#   end
# end


# Pipeline.find_by_name('长沙测试A').destroy()
# Pipeline.find_by_name('长沙测试B').destroy()
# Pipeline.find_by_name('长沙测试C').destroy()
# Pipeline.find_by_name('川浦1').destroy()
# Pipeline.find_by_name('电川3').destroy()
# Pipeline.find_by_name('测试线路').destroy()
# Pipeline.find_by_name('沪金南穗').destroy()
# Pipeline.find_by_name('北沿海').destroy()
# Pipeline.find_by_name('沪宁杭').destroy()



# -----------------------------------------------
# filters
# -----------------------------------------------

before do
  logger.debug 'before filter auth start'

  logger.debug 'before filter auth: / GET'
  pass if request.path_info.eql? '/' and request.request_method.eql? 'GET'
  logger.debug 'before filter auth: /login GET'
  pass if request.path_info.eql? '/login' and request.request_method.eql? 'GET'
  logger.debug 'before filter auth: /login POST'
  pass if request.path_info.eql? '/login' and request.request_method.eql? 'POST'
  logger.debug 'before filter auth: /logout GET'
  pass if request.path_info.eql? '/logout' and request.request_method.eql? 'GET'

  redirect "/", 303 if session[:current_user_id] == nil

  logger.debug 'before filter auth end'

end


# -----------------------------------------------
# controllers
# -----------------------------------------------


get '/' do
  erb :'login', :layout => :layout_blank
end

get '/login' do
  erb :'login', :layout => :layout_blank
end

get '/logout' do
  session[:current_user_id] = nil
  session[:current_user_name] = nil
  redirect to('/')
end

post '/login' do
  account = params['account']
  password = params['password']

  user = User.find_by account: account, password: password

  if user.nil?
    redirect to('/')
  else
    session[:current_menu] = 'home'
    session[:current_user_id] = user.id
    session[:current_user_name] = user.name
    redirect '/monitor/asset-status'
  end
end


get '/monitor/asset-status' do
  session[:current_menu] = 'monitor'
  erb :'monitor/asset_status'
end


get '/setting' do
  session[:current_menu] = 'setting'
  erb :'setting/index'
end


get '/setting/engine_rule' do
  session[:current_menu] = 'setting'
  erb :'setting/engine_rule/index'
end

get '/setting/pipelines' do
  session[:current_menu] = 'setting'

  @pipelines = Pipeline.paginate(:page => params[:page])
  logger.debug "query all pipelines count: #{@pipelines.count}"

  erb :'setting/pipelines/index'
end

# 保存 pipeline
post '/setting/pipelines' do

  logger.debug "post, /setting/pipelines, save new pipeline"
  logger.debug request

  pipeline = Pipeline.find_or_create_by(id: params[:id])
  pipeline.name = params[:name]
  pipeline.no = params[:no]
  pipeline.start_position = params[:start_position]
  pipeline.end_position = params[:end_position]
  pipeline.remark = params[:remark]
  pipeline.save

  current_page = params[:current_page].empty? ? 1 : params[:current_page]
  redirect to("/setting/pipelines?page=#{current_page}")
end


# 删除 pipeline
get '/setting/pipelines/delete/:id' do
  pipeline = Pipeline.find(params[:id])
  pipeline.destroy
  redirect to('/setting/pipelines')
end


# -----------------------------------------------
# Ajax
# -----------------------------------------------

get '/ajax/get_pipelines' do
  Pipeline.all.to_json(:include => :nodes)
end

get '/ajax/get_pipeline/:id' do
  Pipeline.find(params[:id]).to_json(:include => :nodes)
end


#
# get '/welcome/map' do
#   session[:current_menu] = 'home'
#   erb :'welcome/map'
# end
#
#
#
# get '/dashboard' do
#   session[:current_menu] = 'dashboard'
#   erb :'dashboard/index'
# end
#
# get '/dashboard/construction' do
#   erb :'dashboard/construction', :layout => :layout_blank
# end
#
# get '/dashboard/alert' do
#   erb :'dashboard/alert', :layout => :layout_blank
# end
#
#
# # 登录页面路由    ---------------   开始  ----------------
#
# # 领导的欢迎页面
# get '/welcome/manager' do
#   session[:current_menu] = 'home'
#   erb :'welcome/manager'
# end
#
# # 运营商管理人员的欢迎页面
# get '/welcome/staff' do
#   session[:current_menu] = 'home'
#   erb :'welcome/staff'
# end
#
# # 代维人员的欢迎页面
# get '/welcome/operator' do
#   session[:current_menu] = 'home'
#   erb :'welcome/operator'
# end
#
#
# # 登录页面路由    ---------------   结束  ----------------
#
#
# # 资产管理页面    ---------------   开始  ----------------
#
# get '/asset' do
#   session[:current_menu] = 'asset'
#   erb :'asset/index'
# end
#
# post '/asset/search' do
#   session[:current_menu] = 'asset'
#   key = params[:key]
#   @result = {type: 'occ'}.merge $occ_data[1]
#   erb :'asset/index'
# end
#
# get '/asset/occs/:id' do
#   erb :'asset/occ_detail'
# end
#
# get '/asset/manholes/:id' do
#   erb :'asset/manhole'
# end
#
# get '/asset/map' do
#   erb :'asset/map'
# end
#
# # 资产管理页面    ---------------   结束  ----------------
#
#

#
#
# # 小区信息查询页面    ---------------   开始  ----------------
#
#
# get '/community' do
#   session[:current_menu] = 'community'
#   erb :'community/index'
# end
#
# get '/community/detail' do
#   erb :'community/detail'
# end
#
#
# # 小区信息查询页面    ---------------   结束  ----------------
#
#
#
# # 家宽业务    ---------------   开始  ----------------
#
# get '/broadband-family' do
#   session[:current_menu] = 'broadband-family'
#   erb :'broadband-family/index'
# end
#
# get '/broadband-family/map' do
#   erb :'broadband-family/map'
# end
#
# get '/broadband-family/utilization' do
#   erb :'broadband-family/utilization'
# end
#
# get '/broadband-family/family-detail' do
#   erb :'broadband-family/family-detail'
# end
#
# get '/broadband-family/community-detail' do
#   session[:current_menu] = 'broadband-family'
#   erb :'broadband-family/community-detail'
# end
#
# # 家宽业务    ---------------   结束  ----------------
#
#
#
#
# # 巡检管理    ---------------   开始  ----------------
# get '/inspection' do
#   session[:current_menu] = 'inspection'
#   erb :'inspection/index'
# end
#
# get '/inspection/pipe' do
#   erb :'inspection/pipe'
# end
#
# # 巡检管理    ---------------   结束  ----------------
#
#
# # 全平台信息检索    ---------------   开始  ----------------
#
# get '/search' do
#   session[:current_menu] = 'search'
#   erb :'search/index'
# end
#
# # 全平台信息检索    ---------------   结束  ----------------
