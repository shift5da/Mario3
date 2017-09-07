# -----------------------------------------------
# models
# -----------------------------------------------

class User < ActiveRecord::Base
end

class Pipeline < ActiveRecord::Base
  has_many :nodes, -> { order('seq') }, class_name: "PipelineNode", dependent: :destroy


  def device_smartpipe
    DeviceSmartpipe.all.each do |device|
      return [device, 1] if device.tunnel_1.id = self.id
      return [device, 2] if device.tunnel_2.id = self.id
      return [device, 3] if device.tunnel_3.id = self.id
      return [device, 4] if device.tunnel_4.id = self.id
    end
  end

  def rules
    EngineRule.where(pipeline_id: self.id).order('priority desc')
  end

  def top_rule position
    rules = EngineRule.where(pipeline_id: self.id).order('priority desc')
    rules.each do |rule|
      if position >= rule.start_position and position <= rule.end_position
        return rule
      end
    end
  end
end

class PipelineNode < ActiveRecord::Base
  default_scope { order(:distance) }
  belongs_to :pipeline
end

class EngineRule < ActiveRecord::Base
  belongs_to :pipeline
  has_many :events, -> { order('created_at desc') }, foreign_key: "rule_id"
end

class DeviceSmartpipe < ActiveRecord::Base
  belongs_to :tunnel_1, class_name: "Pipeline"
  belongs_to :tunnel_2, class_name: "Pipeline"
  belongs_to :tunnel_3, class_name: "Pipeline"
  belongs_to :tunnel_4, class_name: "Pipeline"

  def pipeline tunnel_id
    return tunnel_1 if tunnel_id == 1
    return tunnel_2 if tunnel_id == 2
    return tunnel_3 if tunnel_id == 3
    return tunnel_4 if tunnel_id == 4

  end
end

class Incident < ActiveRecord::Base
  default_scope { order(created_at: :desc) }
  belongs_to :device, class_name: "DeviceSmartpipe"
  belongs_to :pipeline, class_name: "Pipeline"
  belongs_to :rule, class_name: "EngineRule"

  def get_related_events
    Event.where(id: self.related_events.split(':'))
  end
end

class Event < ActiveRecord::Base
  default_scope { order(created_at: :desc) }
  belongs_to :device, class_name: "DeviceSmartpipe"
  belongs_to :pipeline, class_name: "Pipeline"
  belongs_to :rule, class_name: "EngineRule"
end

# class OriPipeline < ActiveRecord::Base
#   self.table_name = "pipe_line"
#
# end
#
# class OriPipelineNode < ActiveRecord::Base
#   self.table_name = "pipe_line_node"
# end





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
