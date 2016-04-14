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

The BOT APIs can only be called from registered servers. So you must use a service that provides your Heroku application with a fixed set of static IP addresses for outbound requests.  
If you want to use [Fixie](https://elements.heroku.com/addons/fixie), execute a following heroku command. This command set `FIXIE_URL` automatically.

```sh
$ heroku addons:create fixie:tricycle
```

If you want to use the other service, please set `HUBOT_LINE_PROXY_URL` like below.

```sh
$ heroku config:add HUBOT_LINE_PROXY_URL="your_proxy_url"
```

If you want to change a callback url, you should set `HUBOT_LINE_CALLBACK_PATH` like following.

```sh
$ heroku config:add HUBOT_LINE_CALLBACK_PATH="/path/to/callback"
```

### Non-Heroku environment variables

```sh
$ export HUBOT_LINE_CHANNEL_ID="your_channel_id"
$ export HUBOT_LINE_CHANNEL_SECRET="your_channel_secret"
$ export HUBOT_LINE_CHANNEL_MID="your_channel_mid"
```

The following environment variables are optional.

```sh
$ export HUBOT_LINE_CALLBACK_PATH="/path/to/callback"
$ export HUBOT_LINE_PROXY_URL="your_proxy_url"
```

### LINE Platform

You will need to register a callback URL on LINE Platform. Please refer to [Registering a callback URL](https://developers.line.me/bot-api/getting-started-with-bot-api-trial#register_callback_url).  
You need to register IP addresses on your server whitelist. Please refer to [Server whitelist](https://developers.line.me/bot-api/getting-started-with-bot-api-trial#whitelists).

## Scripting

### Listening

This adapter can listen LINE features as messages. LINE features this library supported are image and video, audio, location, sticker, contact, friend, block.  
To listen, you need to register a listener in your own script. For example, if you want to listen to when hubot receives any sticker, you can write as follows.

```coffeescript
{LineStickerListener} = require 'hubot-line'

module.exports = (robot) ->
  robot.listeners.push new LineStickerListener robot, (() -> true), (res) ->
    res.send "Receiced a sticker. id: #{res.message.id} STKPKGID: #{res.message.STKPKGID}"
```

Listener constructor has 3 parameters.

* robot - A Robot instance.
* matcher - A Function that determines if this listener should trigger the callback.
* callback - A Function that is triggered if the incoming message matches.

Callback parameter contains the message property, and all of messages have a property of id.

#### Listeners

Listeners are provided for each LINE feature.

* LineImageListener - Listen image messages
* LineVideoListener - Listen video messages
* LineAudioListener - Listen audio messages
* LineLocationListener - Listen location messages  
A location message has extra properties.  
    * title - "Location data" string
    * address
    * latitude
    * longitude
* LineStickerListener - Listen sticker messages  
A sticker message has extra properties..  
    * STKPKGID - The package ID of the sticker
    * STKID - The sticker ID
    * STKVER - The sticker’s version number
    * STKTXT - The text of the sticker
* LineContactListener - Listen contact messages  
A contact message has extra properties.  
    * mid - The MID value of the person sent as this contact
    * displayName - The nickname of the person sent as this contact
* LineRawMessageListener - Listen features that summarized followings: image and video, audio, location, sticker, contact
* LineFriendListener - Listen operations that added as friend (including canceling block)
A friend message has extra properties.  
    * mid - MID of user who added your account as a friend
* LineBlockListener - Listen operations that blocked bot account
A block message has extra properties.  
    * mid - MID of user who blocked your account
* LineRawOperationListener - Listen operations that summarized the followings: friend, block

## Contribute

Just send pull request if needed or fill an issue !

## License

The MIT License. See `LICENSE` for details.
