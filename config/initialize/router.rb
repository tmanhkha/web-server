module Frack
  class Router
    attr_reader :app, :routes

    def initialize(app, &block)
      @app = app
      @routes = {}
      instance_eval(&block) if block_given?
    end

    def call(env)
      if (mapping = routes[env['PATH_INFO']])
        env.merge!(controller_action(mapping))
        app.call(env)
      else
        Rack::Response.new('Not Found', 404)
      end
    end

    def controller_action(mapping)
      Hash[ %w(controller action).zip mapping.split('#') ]
    end

    def get(route)
      self.routes.merge!(route)
    end
  end
end