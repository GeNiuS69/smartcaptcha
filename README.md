# SmartCaptcha

This gem provides helper methods for the [Yandex SmartCaptcha](https://cloud.yandex.com/en/services/smartcaptcha).

In your views you can use the `recaptcha_tags` method to embed the needed javascript, and you can validate in your controllers with `verify_recaptcha` or `verify_recaptcha!`, which raises an error on failure.

This is adaptation of [reCAPTCHA](https://github.com/ambethia/recaptcha). This service has a lot of difference that's why it isn't fork or PR.

## Installation

Add

    gem 'smartcaptcha', github: 'https://github.com/GeNiuS69/smartcaptcha'
to your Gemfile and run

    bundle install

## Obtaining a key

[Guide to obtain keys.](https://cloud.yandex.com/en/docs/smartcaptcha/operations/get-keys)

## Sinatra / Rack / Ruby installation

See [sinatra demo](/demo/sinatra) for details.

 - add `gem 'smartcaptcha', github: 'https://github.com/GeNiuS69/smartcaptcha'` to `Gemfile`
 - set env variables
 - `include Smartcaptcha::Adapters::ViewMethods` where you need `recaptcha_tags`
 - `include Smartcaptcha::Adapters::ControllerMethods` where you need `verify_recaptcha`

## Usage

### `smartcaptcha_tags`

The following options are available:

| Option              | Description |
|---------------------|-------------|
| `:site_key`         | Override site API key from configuration |
| `:id`               | Specify an html id attribute (default: `nil`) |
| `:callback`         | Optional. Name of success callback function, executed when the user submits a successful response |

[JavaScript resource (captcha.js) parameters](https://cloud.yandex.com/en/docs/smartcaptcha/concepts/widget-methods#common-method):

| Option              | Description |
|---------------------|-------------|
| `:hl`               | Optional. Forces the widget to render in a specific language. Auto-detects the user's language if unspecified. |
| `:script_async`     | Set to `false` to load the external `captcha.js` resource synchronously. (default: `true`) |
| `:script_defer`     | Set to `true` to defer loading of external `captcha.js` until HTML document has been parsed. (default: `true`) |

Any unrecognized options will be added as attributes on the generated tag.

Note that you cannot submit/verify the same response token more than once or you will get a
`timeout-or-duplicate` error code. If you need reset the captcha and generate a new response token,
then you need to call `window.smartCaptcha.reset()`.

### `verify_recaptcha`

This method returns `true` or `false` after processing the response token from the SmartCaptcha widget.
This is usually called from your controller, as seen [above](#rails-installation).


Some of the options available:

| Option                    | Description |
|---------------------------|-------------|
| `:message`                | Custom error message.
| `:env`                    | Current environment. The request to verify will be skipped if the environment is specified in configuration under `skip_verify_env`
| `:json`                   | Boolean; defaults to false; if true, will submit the verification request by POST with the request data in JSON


### `invisible_smartcaptcha_tags`

In progress

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/GeNiuS69/smartcaptcha.
## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
