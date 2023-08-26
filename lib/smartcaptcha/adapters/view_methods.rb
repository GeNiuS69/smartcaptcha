# frozen_string_literal: true

module Smartcaptcha
  module Adapters
    module ViewMethods
      # Renders a SmartCaptcha [Checkbox](https://cloud.yandex.ru/docs/smartcaptcha/concepts/validation) widget
      def smartcaptcha_tags(options = {})
        ::Smartcaptcha::Helpers.smartcaptcha_tags(options)
      end

      # Renders a [Invisible SmartCaptcha](https://cloud.yandex.ru/docs/smartcaptcha/concepts/invisible-captcha)
      def invisible_smartcaptcha_tags(options = {})
        ::Smartcaptcha::Helpers.invisible_smartcaptcha_tags(options)
      end
    end
  end
end
