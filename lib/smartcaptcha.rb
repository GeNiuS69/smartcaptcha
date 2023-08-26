# frozen_string_literal: true

require 'json'
require 'net/http'
require 'uri'

require 'smartcaptcha/configuration'
require 'smartcaptcha/helpers'
require 'smartcaptcha/adapters/controller_methods'
require 'smartcaptcha/adapters/view_methods'

module Smartcaptcha
  DEFAULT_TIMEOUT = 3

  class SmartcaptchaError < StandardError
  end

  class VerifyError < SmartcaptchaError
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    config = configuration
    yield(config)
  end

  def self.skip_env?(env)
    configuration.skip_verify_env.include?(env || configuration.default_env)
  end

  def self.invalid_response?(resp)
    resp.empty?
  end

  def self.verify_via_api_call(response, options)
    secret_key = options.fetch(:secret_key) { configuration.secret_key! }
    verify_hash = { 'secret' => secret_key, 'token' => response }
    verify_hash['ip'] = options[:remote_ip] if options.key?(:remote_ip)

    reply = api_verification(verify_hash, timeout: options[:timeout], json: options[:json])
    success = reply['status'].to_s == 'ok'

    if options[:with_reply] == true
      [success, reply]
    else
      success
    end
  end

  def self.http_client_for(uri:, timeout: nil)
    timeout ||= DEFAULT_TIMEOUT
    http = if configuration.proxy
      proxy_server = URI.parse(configuration.proxy)
      Net::HTTP::Proxy(proxy_server.host, proxy_server.port, proxy_server.user, proxy_server.password)
    else
      Net::HTTP
    end
    instance = http.new(uri.host, uri.port)
    instance.read_timeout = instance.open_timeout = timeout
    instance.use_ssl = true if uri.port == 443

    instance
  end

  def self.api_verification(verify_hash, timeout: nil, json: false)
    if json
      uri = URI.parse(configuration.verify_url)
      request = Net::HTTP::Post.new(uri.request_uri)
      request['Content-Type'] = 'application/json; charset=utf-8'
      request.body = JSON.generate(verify_hash)
    else
      query = URI.encode_www_form(verify_hash)
      uri = URI.parse("#{configuration.verify_url}?#{query}")
      request = Net::HTTP::Get.new(uri.request_uri)
    end
    http_instance = http_client_for(uri: uri, timeout: timeout)
    JSON.parse(http_instance.request(request).body)
  end
end
