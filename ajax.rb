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
      event_id: event.id,
      pipeline_name: event.pipeline.name,
      position: event.position,
      created_at: event.created_at.strftime("%F %T")
    }
  end
  result.to_json
end

get '/ajax/unhandled_incidents_today' do
  result = []
  Incident.where(is_handled: false).where("DATE(created_at) = ?", Date.today).each do |incident|
    incident_start_node = nil
    incident_end_node = nil

    incident.pipeline.nodes.each do |node|
      if incident.position > node.distance
        incident_start_node = node
      else
        incident_end_node = node
        break
      end
    end

    # 去除当天重复的告警
    if result.collect{|n| n[:position]}.include? incident.position
      result.each do |n|
        if n[:position] == incident.position
          n[:occured_count] = n[:occured_count] + 1
        end
      end
    else
      result << {
        start_lng: incident_start_node.lng,
        start_lat: incident_start_node.lat,
        start_distance: incident_start_node.distance,
        end_lng: incident_end_node.lng,
        end_lat: incident_end_node.lat,
        end_distance: incident_end_node.distance,
        position: incident.position,
        occured_count: 1,
        created_at: incident.created_at.strftime("%F %T")
      }
    end
  end
  result.to_json
end
