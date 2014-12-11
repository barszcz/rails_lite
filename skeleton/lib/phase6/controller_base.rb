require_relative '../phase5/controller_base'

module Phase6
  class ControllerBase < Phase5::ControllerBase
    # use this with the router to call action_name (:index, :show, :create...)
    def invoke_action(name)
      self.send(name)
    end

    def initialize(req, res, route_params = {})
      super
      @params = Phase5::Params.new(req, route_params)
    end
  end
end
