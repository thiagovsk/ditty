# frozen_string_literal: true

module Ditty
  module Helpers
    module Authentication
      def current_user
        if env['rack.session'].nil? || env['rack.session']['user_id'].nil?
          self.current_user = anonymous_user
        end
        @users ||= Hash.new { |h, k| h[k] = User[k] }
        @users[env['rack.session']['user_id']]
      end

      def current_user=(user)
        env['rack.session'] = {} if env['rack.session'].nil?
        env['rack.session']['user_id'] = user.id if user
      end

      def authenticate
        authenticated?
      end

      def authenticated?
        current_user && !current_user.role?('anonymous')
      end

      def authenticate!
        raise NotAuthenticated unless authenticated?
        true
      end

      def logout
        env['rack.session'].delete('user_id')
      end

      def check_basic(request)
        auth = Rack::Auth::Basic::Request.new(request.env)
        return false unless auth.provided? && auth.basic?
        username = auth.credentials[0]
        identity = ::Ditty::Identity.find(username: username)
        identity ||= ::Ditty::Identity.find(username: CGI.unescape(username))
        return false unless identity
        self.current_user = identity.user if identity.authenticate(auth.credentials[1])
      end

      def anonymous_user
        return @anonymous_user if defined? @anonymous_user
        @anonymous_user ||= begin
          role = ::Ditty::Role.where(name: 'anonymous').first
          ::Ditty::User.where(roles: role).first unless role.nil?
        end
      end
    end

    class NotAuthenticated < StandardError
    end
  end
end
