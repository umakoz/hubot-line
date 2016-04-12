hubot-line
==============

This is a [Hubot](https://hubot.github.com/) adapter to use with [LINE](http://line.me/).  
This library is using [LINE BOT API](https://developers.line.me/bot-api/overview).  
Now, this adapter supports [BOT API Trial](https://developers.line.me/type-of-accounts/bot-api-trial) only. Sorry, [Business Connect](https://developers.line.me/type-of-accounts/business-connect) is not available yet.

## Installation

* Add `hubot-line` as a dependency in your hubot's `package.json`
* Install dependencies with `npm install`
* Run hubot with `bin/hubot -a line`

### Note if running on Heroku

You will need to change the process type from `app` to `web` in the `Procfile`.

## Usage

Create a business account at the [Business Center](https://business.line.me/).  
Add BOT API Trial on your business account page.  
Then you will need to set some environment variables to use this adapter.

### Environment variables

The following environment variables must be defined.

| Variable name | Description |
|---|---|
| HUBOT_LINE_CHANNEL_ID | Your bot's Channel ID |
| HUBOT_LINE_CHANNEL_SECRET | Your bot's Channel Secret |
| HUBOT_LINE_CHANNEL_MID | Your bot's MID |

The following environment variables are optional.

| Variable name | Default value | Description |
|---|---|---|
| HUBOT_LINE_PROXY_URL | (NULL) | Primary url for tunneling through a HTTP proxy |
| FIXIE_URL | (NULL) | Secondary url for tunneling through a HTTP proxy<br> This value is ready for [Fixie](https://elements.heroku.com/addons/fixie) |
| HUBOT_LINE_CALLBACK_PATH | /hubot/line/callback | Path to receive requests sent from the LINE platform |

### Heroku

    $ heroku config:add HUBOT_LINE_CHANNEL_ID="your_channel_id"
    $ heroku config:add HUBOT_LINE_CHANNEL_SECRET="your_channel_secret"
    $ heroku config:add HUBOT_LINE_CHANNEL_MID="your_channel_mid"

The BOT APIs can only be called from registered servers. So you must use a service provides your Heroku application with a fixed set of static IP addresses for outbound requests.  
If you want to use [Fixie](https://elements.heroku.com/addons/fixie), execute a following heroku command. This command set `FIXIE_URL` automatically.

    $ heroku addons:create fixie:tricycle

If you want to use the other service, please set `HUBOT_LINE_PROXY_URL` like below.

    $ heroku config:add HUBOT_LINE_PROXY_URL="your_proxy_url"

If you want to change a callback url, you should set `HUBOT_LINE_CALLBACK_PATH` like following.

    $ heroku config:add HUBOT_LINE_CALLBACK_PATH="/path/to/callback"

### Non-Heroku environment variables

    $ export HUBOT_LINE_CHANNEL_ID="your_channel_id"
    $ export HUBOT_LINE_CHANNEL_SECRET="your_channel_secret"
    $ export HUBOT_LINE_CHANNEL_MID="your_channel_mid"

The following environment variables are optional.

    $ export HUBOT_LINE_CALLBACK_PATH="/path/to/callback"
    $ export HUBOT_LINE_PROXY_URL="your_proxy_url"

### LINE Platform

You will need to register a callback URL on LINE Platform. Please refer to [Registering a callback URL](https://developers.line.me/bot-api/getting-started-with-bot-api-trial#register_callback_url).  
You need to register IP addresses on your server whitelist. Please refer to [Server whitelist](https://developers.line.me/bot-api/getting-started-with-bot-api-trial#whitelists).

## Contribute

Just send pull request if needed or fill an issue !

## License

The MIT License. See `LICENSE` for details.
