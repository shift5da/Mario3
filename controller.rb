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
  logger.debug 'before filter websocket: /ws GET'
  pass if request.path_info.eql? '/ws' and request.request_method.eql? 'GET'

  
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

get '/alert/incidents' do
  session[:current_menu] = 'alert'
  @incidents = Incident.paginate(:page => params[:page])
  erb :'alert/incidents'
end

get '/alert/events' do
  session[:current_menu] = 'alert'
  @events = Event.paginate(:page => params[:page])
  erb :'alert/events'
end


get '/setting' do
  session[:current_menu] = 'setting'
  erb :'setting/index'
end


# 规则 index
get '/setting/engine_rules' do
  session[:current_menu] = 'setting'
  @rules = EngineRule.all.order('pipeline_id')
  erb :'setting/engine_rule/index'
end

# 保存 规则
post '/setting/engine_rules' do
  logger.debug "post, /setting/engine_rules"
  logger.debug request

  rule = EngineRule.find_or_create_by(id: params[:id])
  rule.name = params[:name]
  rule.pipeline_id = params[:pipeline_id]
  rule.start_position = params[:start_position]
  rule.end_position = params[:end_position]
  rule.timescope = params[:timescope]
  rule.count = params[:count]
  rule.priority = params[:priority]
  rule.remark = params[:remark]
  rule.save

  redirect to("/setting/engine_rules")

end

# 删除 pipeline
get '/setting/engine_rules/delete/:id' do
  rule = EngineRule.find(params[:id])
  rule.destroy
  redirect to('/setting/engine_rules')
end

# 管线 index
get '/setting/pipelines' do
  session[:current_menu] = 'setting'
  @pipelines = Pipeline.paginate(:page => params[:page])
  erb :'setting/pipelines/index'
end

# 保存 pipeline
post '/setting/pipelines' do

  logger.debug "post, /setting/pipelines"
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


# 智能管道设备 index
get '/setting/device_smartpipes' do
  session[:current_menu] = 'setting'
  @devices = DeviceSmartpipe.paginate(:page => params[:page])
  erb :'setting/device_smartpipes/index'
end

# 保存 智能管道设备
post '/setting/device_smartpipes' do

  logger.debug "post, /setting/device_smartpipes"
  logger.debug request

  device = DeviceSmartpipe.find_or_create_by(id: params[:id])
  device.name = params[:name]
  device.no = params[:no]
  device.tunnel_1_id = params[:tunnel_1_id]
  device.tunnel_2_id = params[:tunnel_2_id]
  device.tunnel_3_id = params[:tunnel_3_id]
  device.tunnel_4_id = params[:tunnel_4_id]
  device.remark = params[:remark]
  device.save

  redirect to("/setting/device_smartpipes")
end


# 删除 智能管道设备
get '/setting/device_smartpipes/delete/:id' do
  device = DeviceSmartpipe.find(params[:id])
  device.destroy
  redirect to('/setting/device_smartpipes')
end





# -----------------------------------------------
# HTTP 请求接口
# -----------------------------------------------

get '/handle_event' do
  content = params[:content]
  unless content.empty?

    #0110 0007 sh0101 2567023, 注意中间无空格 0110是智能管道，0007是消息长度，sh0103是上海1号机1号通道，2567023是25670米处有类型2电镐施工 强度是3级

    logger.debug '/handle_event'
    logger.debug "content = #{content}"
    logger.debug "机器标志：" + content[0,4]
    logger.debug "消息长度：" + content[4,4]
    logger.debug "城市：" + content[8,2]
    logger.debug "设备编号：" + content[10,2]
    logger.debug "通道编号：" + content[12,2]
    logger.debug "告警位置：" + content[14,5]
    logger.debug "施工类型：" + content[19,1]
    logger.debug "施工强度：" + content[20,1]

    # 保存 event
    event = Event.new
    device = DeviceSmartpipe.find(content[10,2].to_i)
    event.device = device
    event.tunnel = content[12,2].to_i
    event.position = content[14,5].to_i
    event.category = content[19,1].to_i
    event.intensity = content[20,1].to_i
    event.pipeline = device.pipeline event.tunnel
    event.rule = event.pipeline.top_rule event.position
    event.save

    # 根据线路，查找对应的规则（只能对应唯一规则）

    if event.rule.nil?
      # 如果事件没有匹配的规则

    else
      rule = event.rule
      if event.rule.first_occur_at.nil?    #如果是第一次进入规则
        rule.first_occur_at = Time.now
        rule.occured_count = 1
        rule.related_events = event.id.to_s + ":"
        rule.save
      else
        # 检查与第一次发生的时间相比较，是否在timescope之内
        if (event.created_at.to_i - rule.first_occur_at.to_i) <= rule.timescope
          # 在 timescope 之内

          if (rule.occured_count + 1) == rule.count

            # 符合timescope 和 count， 产生incident
            incident = Incident.new
            incident.device = event.device
            incident.tunnel = event.tunnel
            incident.rule = rule
            incident.pipeline = event.pipeline
            incident.position = event.position
            incident.is_viewed = false
            incident.is_handled = false
            incident.related_events = rule.related_events + event.id.to_s
            incident.save

            # 将rule恢复
            rule.first_occur_at = nil
            rule.occured_count = 0
            rule.related_events = nil
            rule.save

            # 通过websocket 发送通知
            EM.next_tick { settings.sockets.each{|s| s.send("new_incident") } }
          else
            rule.occured_count = rule.occured_count + 1
            rule.related_events = rule.related_events + event.id.to_s + ":"
            rule.save
          end
        else
          # 超出 timescope，将rule中已经记录的数据更新
          rule.first_occur_at = nil
          rule.occured_count = 0
          rule.related_events = nil
          rule.save
        end
      end
    end
  end
end


# -----------------------------------------------
# Websocket 请求接口
# -----------------------------------------------
get '/ws' do
  if !request.websocket?

  else
    request.websocket do |ws|
      ws.onopen do
        ws.send("Hello World!")
        settings.sockets << ws
      end
      ws.onmessage do |msg|
        # EM.next_tick { settings.sockets.each{|s| s.send(msg) } }
      end
      ws.onclose do
        # warn("websocket closed")
        settings.sockets.delete(ws)
      end
    end
  end
end

get '/demo' do
  erb :'demo'
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
