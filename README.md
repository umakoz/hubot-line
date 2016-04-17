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

### Listen

This adapter can listen LINE actions as messages. LINE actions this library can listen are image and video, audio, location, sticker, contact, friend, block.  
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

Callback parameter `res` contains the message property, and all of messages have a property of id.

#### Listeners

Listeners are provided for each LINE action.

* LineImageListener - Listen image messages
A image message has extra methods. (Refer to following content and previewContent section)  
    * content - a user’s image
    * previewContent - a thumbnail preview
* LineVideoListener - Listen video messages
A video message has extra methods. (Refer to following content and previewContent section)  
    * content - a user’s video
    * previewContent - a thumbnail preview
* LineAudioListener - Listen audio messages
A audio message has extra methods. (Refer to following content and previewContent section)  
    * content - a user’s audio
* LineLocationListener - Listen location messages  
A location message has extra properties.  
    * title - "Location data" string
    * address - Address
    * latitude - Latitude
    * longitude - Longitude
* LineStickerListener - Listen sticker messages  
A sticker message has extra properties.  
    * STKPKGID - The package ID of the sticker
    * STKID - The sticker ID
    * STKVER - The sticker’s version number
    * STKTXT - The text of the sticker
* LineContactListener - Listen contact messages  
A contact message has extra properties.  
    * mid - The MID value of the person sent as this contact
    * displayName - The nickname of the person sent as this contact
* LineRawMessageListener - Listen actions that summarized followings: image and video, audio, location, sticker, contact
* LineFriendListener - Listen operations that added as friend (including canceling block)  
A friend message has extra properties.  
    * mid - MID of user who added your account as a friend
* LineBlockListener - Listen operations that blocked bot account  
A block message has extra properties.  
    * mid - MID of user who blocked your account
* LineRawOperationListener - Listen operations that summarized the followings: friend, block

##### Content and previewContent

LINE image and video messages have content and previewContent that users send. Also audio messages have content.
You can retrieve the content and previewContent of a user’s message like following.

```coffeescript
{LineImageListener} = require 'hubot-line'

module.exports = (robot) ->
  robot.listeners.push new LineImageListener robot, (() -> true), (res) ->
    res.message.content (content) ->
      res.message.previewContent (previewContent) ->
        # process binary data of content and previewContent.
```

Please process binary data of content and previewContent, as you want.


### Emote

The `res` parameter is an instance of Response. With it, you can emote a line action. For example:

```coffeescript
{LineStickerListener, LineStickerAction} = require 'hubot-line'

module.exports = (robot) ->
  robot.listeners.push new LineStickerListener robot, (() -> true), (res) ->
    res.emote new LineStickerAction res.message.STKID, res.message.STKPKGID
```

Above an example, LineStickerListener emote a sticker action that sender did.
To emote a sticker, place 2 parameters, STKID and STKPKGID.  
LINE actions this library can emote are text and image, video, audio, location, sticker.  

#### Actions

This library has following LINE actions.

* LineTextAction - Emote texts  
A text action has a parameter.  
    * text - String you want to send. Messages can contain up to 1024 characters.
* LineImageAction - Emote images  
A image action has 2 parameters.  
    * originalContentUrl - URL of image. Only JPEG format supported. Image size cannot be larger than 1024×1024
    * previewImageUrl - URL of thumbnail image. For preview. Only JPEG format supported. Image size cannot be larger than 240×240
* LineVideoAction - Emote videos  
A video action has 2 parameters.  
    * originalContentUrl - URL of the movie. The "mp4" format is recommended
    * previewImageUrl - URL of thumbnail image used as a preview
* LineAudioAction - Emote audios  
A audio action has 2 parameters.  
    * originalContentUrl - URL of audio file. The "m4a" format is recommended
    * AUDLEN - Length of voice message. The unit is given in milliseconds
* LineLocationAction - Emote locations  
A location action has 3 parameters.  
    * title - String used to explain the location information (example: name of restaurant, address)
    * latitude - Latitude
    * longitude - Loingitude
* LineStickerAction - Emote stickers  
You can use the stickers shown in the [sticker list](https://developers.line.me/wp-content/uploads/2016/04/sticker_list.xlsx). A sticker action has 3 parameters.  
    * STKID - ID of the sticker
    * STKPKGID - Package ID of the sticker
    * STKVER - Optional. Version number of the sticker. If omitted, the latest version number is applied

## Contribute

Just send pull request if needed or fill an issue !

## License

The MIT License. See `LICENSE` for details.
