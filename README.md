hubot-line
==============

This is a Hubot adapter to use with [LINE](http://line.me/).
Now, this supports LINE BOT API Trial only.

## Installation

* Add `hubot-line` as a dependency in your hubot's `package.json`
* Install dependencies with `npm install`
* Run hubot with `bin/hubot -a line

### Note if running on Heroku

You will need to change the process type from `app` to `web` in the `Procfile`.

## Usage

You will need to set some environment variables to use this adapter.

### Heroku

    % heroku config:add HUBOT_LINE_CHANNEL_ID="channel_id"
    % heroku config:add HUBOT_LINE_CHANNEL_SECRET="channel_secret"
    % heroku config:add HUBOT_LINE_CHANNEL_MID="channel_mid"
    % heroku config:add HUBOT_LINE_PROXY="fixie_url"
    # optional
    % heroku config:add HUBOT_LINE_CALLBACK_PATH="/hubot/line/callback"

### Non-Heroku environment variables

    % export HUBOT_LINE_CHANNEL_ID="channel_id"
    % export HUBOT_LINE_CHANNEL_SECRET="channel_secret"
    % export HUBOT_LINE_CHANNEL_MID="channel_mid"
    # optional
    % export HUBOT_LINE_CALLBACK_PATH="/hubot/line/callback"
    % export HUBOT_LINE_PROXY="proxy_url"

Then you will need to register a callback URL on LINE Platform.

## Contribute

Just send pull request if needed or fill an issue !

## License

The MIT License. See `LICENSE` for details.
