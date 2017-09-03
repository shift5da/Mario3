# -----------------------------------------------
# Ajax
# -----------------------------------------------

get '/ajax/get_pipelines' do
  Pipeline.all.to_json(:include => :nodes)
end

get '/ajax/get_pipeline/:id' do
  Pipeline.find(params[:id]).to_json
end

get '/ajax/get_engine_rule/:id' do
  EngineRule.find(params[:id]).to_json
end

get '/ajax/device_smartpipe/:id' do
  DeviceSmartpipe.find(params[:id]).to_json
end

get '/ajax/get_unviewed_incidents' do
  Incident.where(is_viewed: false).to_json
end

get '/ajax/get_today_incidents' do
  Incident.where("DATE(created_at) = ?", Date.today).to_json
end
