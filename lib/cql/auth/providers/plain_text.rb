# encoding: utf-8

module Cql
  module Auth
    module Providers
      # Auth provider used for Cassandra's built in authentication.
      #
      # @note No need to instantiate this class manually, use {Cql::Builder#with_credentials} method and one will be created automatically for you.
      class PlainText
        # Authenticator used for Cassandra's built in authentication,
        # see {Cql::Auth::Providers::PlainText}
        # @private
        class Authenticator
          # @private
          def initialize(username, password)
            @username = username
            @password = password
          end

          def initial_response
            "\x00#{@username}\x00#{@password}"
          end

          def challenge_response(token)
          end

          def authentication_successful(token)
          end
        end

        # @param username [String] username to use for authentication to Cassandra
        # @param password [String] password to use for authentication to Cassandra
        def initialize(username, password)
          @username = username
          @password = password
        end

        # Returns a PlainText Authenticator only if `org.apache.cassandra.auth.PasswordAuthenticator` is given.
        # @param authentication_class [String] must equal to `org.apache.cassandra.auth.PasswordAuthenticator`
        # @return [Cql::Auth::Authenticator] when `authentication_class == "org.apache.cassandra.auth.PasswordAuthenticator"`
        # @return [nil] for all other values of `authentication_class`
        def create_authenticator(authentication_class)
          if authentication_class == PASSWORD_AUTHENTICATOR_FQCN
            Authenticator.new(@username, @password)
          end
        end

        private

        # @private
        PASSWORD_AUTHENTICATOR_FQCN = 'org.apache.cassandra.auth.PasswordAuthenticator'.freeze
      end
    end
  end
end
