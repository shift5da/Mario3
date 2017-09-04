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

get '/ajax/get_related_events/:incident_id' do
  result = []
  Incident.find(params[:incident_id]).get_related_events.each do |event|
    result << {
      pipeline_id: event.pipeline.id,
      pipeline_name: event.pipeline.name,
      position: event.position,
      created_at: event.created_at.strftime("%F %T")
    }
  end
  result.to_json
end

get '/ajax/get_today_incidents' do
  Incident.where("DATE(created_at) = ?", Date.today).to_json(include: pipeline)
end
