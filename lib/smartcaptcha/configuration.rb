# frozen_string_literal: true

module Smartcaptcha
  class Configuration
    DEFAULTS = {
      'server_url' => 'https://smartcaptcha.yandexcloud.net/captcha.js',
      'verify_url' => 'https://smartcaptcha.yandexcloud.net/validate'
    }.freeze

    attr_accessor :default_env, :skip_verify_env, :proxy, :client_key, :server_key
    attr_writer :api_server_url, :verify_url

    def initialize # :nodoc:
      @default_env = ENV['RAILS_ENV'] || ENV['RACK_ENV'] || (Rails.env if defined? Rails.env)
      @skip_verify_env = %w[test cucumber]

      @client_key = ENV.fetch('SMARTCAPTCHA_CLIENT_KEY', nil)
      @server_key = ENV.fetch('SMARTCAPTCHA_SERVER_KEY', nil)

      @verify_url = nil
      @api_server_url = nil
    end

    def client_key!
      client_key || raise(RecaptchaError, "No client key specified.")
    end

    def server_key!
      server_key || raise(RecaptchaError, "No server key specified.")
    end

    alias_method :site_key!, :client_key!
    alias_method :secret_key!, :server_key!

    def api_server_url
      @api_server_url || DEFAULTS.fetch('server_url')
    end

    def verify_url
      @verify_url || DEFAULTS.fetch('verify_url')
    end
  end
end
