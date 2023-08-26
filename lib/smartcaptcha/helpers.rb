module Smartcaptcha
  module Helpers
    DEFAULT_ERRORS = {
      recaptcha_unreachable: 'Oops, we failed to validate your reCAPTCHA response. Please try again.',
      verification_failed: 'reCAPTCHA verification failed, please try again.'
    }.freeze

    def self.smartcaptcha_tags(options)
      html, tag_attributes = components(options.dup)
      html << %(<div #{tag_attributes}></div>\n)
    end

    def self.to_error_message(key)
      default = DEFAULT_ERRORS.fetch(key) { raise ArgumentError "Unknown SmartCaptcha error - #{key}" }
      to_message("smartcaptcha.errors.#{key}", default)
    end

    if defined?(I18n)
      def self.to_message(key, default)
        I18n.translate(key, default: default)
      end
    else
      def self.to_message(_key, default)
        default
      end
    end

    private_class_method def self.components(options)
      html = ''
      attributes = {}

      options = options.dup
      env = options.delete(:env)
      site_key = options.delete(:site_key)
      container_id = options.delete(:id)
      script_async = options.delete(:script_async)
      script_defer = options.delete(:script_defer)

      data_attribute_keys = [:hl, :callback]
      data_attributes = {}
      data_attribute_keys.each do |data_attribute|
        value = options.delete(data_attribute)
        data_attributes["data-#{data_attribute.to_s.tr('_', '-')}"] = value if value
      end

      unless Smartcaptcha.skip_env?(env)
        site_key ||= Smartcaptcha.configuration.site_key!
        script_url = Smartcaptcha.configuration.api_server_url
        async_attr = "async" if script_async != false
        defer_attr = "defer" if script_defer != false
        html << %(<script src="#{script_url}" #{async_attr} #{defer_attr}></script>\n)
        attributes["data-sitekey"] = site_key
        attributes.merge! data_attributes
      end

      # The remaining options will be added as attributes on the tag.
      attributes["class"] = "smart-captcha"
      attributes["id"] = container_id
      tag_attributes = attributes.merge(options).map { |k, v| %(#{k}="#{v}") }.join(" ")

      [html, tag_attributes]
    end
  end
end
