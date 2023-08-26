# frozen_string_literal: true

module Smartcaptcha
  module Adapters
    module ControllerMethods
      private

      # Your private API can be specified in the +options+ hash or preferably
      # using the Configuration.
      def verify_smartcaptcha(options = {})
        return true if Smartcaptcha.skip_env?(options[:env])

        smartcaptcha_response = smartcaptcha_response_token

        begin
          verified = if Smartcaptcha.invalid_response?(smartcaptcha_response)
            false
          else
            unless options[:skip_remote_ip]
              remoteip = (request.respond_to?(:remote_ip) && request.remote_ip) || (env && env['REMOTE_ADDR'])
              options = options.merge(remote_ip: remoteip.to_s) if remoteip
            end

            success, @_smartcaptcha_reply =
              Smartcaptcha.verify_via_api_call(smartcaptcha_response, options.merge(with_reply: true))
            success
          end

          if verified
            flash.delete(:smartcaptcha_error) if smartcaptcha_flash_supported?
            true
          else
            smartcaptcha_error(
              options.fetch(:message) { Smartcaptcha::Helpers.to_error_message(:verification_failed) }
            )
            false
          end
        rescue Timeout::Error
          raise SmartcaptchaError, 'Smartcaptcha unreachable.'
        rescue StandardError => e
          raise SmartcaptchaError, e.message, e.backtrace
        end
      end

      def verify_smartcaptcha!(options = {})
        verify_smartcaptcha(options) || raise(VerifyError)
      end

      def smartcaptcha_reply
        @_smartcaptcha_reply if defined?(@_smartcaptcha_reply)
      end

      def smartcaptcha_error(message)
        if smartcaptcha_flash_supported?
          flash[:smartcaptcha_error] = message
        end
      end

      def smartcaptcha_flash_supported?
        request.respond_to?(:format) && request.format == :html && respond_to?(:flash)
      end

      # Extracts response token from params. params['g-smartcaptcha-response-data'] for smartcaptcha_v3 or
      # params['g-smartcaptcha-response'] for smartcaptcha_tags and invisible_smartcaptcha_tags and should
      # either be a string or a hash with the action name(s) as keys. If it is a hash, then `action`
      # is used as the key.
      # @return [String] A response token if one was passed in the params; otherwise, `''`
      def smartcaptcha_response_token
        response_param = params['smart-token']

        if response_param.is_a?(String)
          response_param
        else
          ''
        end
      end
    end
  end
end
