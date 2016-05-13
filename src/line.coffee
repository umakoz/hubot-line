{Robot, Adapter, TextMessage} = require 'hubot'
HttpsProxyAgent = require 'https-proxy-agent'
{EventEmitter} = require 'events'
{LineRawMessage, LineImageMessage, LineVideoMessage, LineAudioMessage, LineLocationMessage, LineStickerMessage, LineContactMessage, LineRawOperation, LineFriendOperation, LineBlockOperation} = require './message'
{LineAction, LineTextAction, LineImageAction, LineVideoAction, LineAudioAction, LineLocationAction, LineStickerAction} = require './action'



class LineAdapter extends Adapter

  send: (envelope, strings...) ->
    @robot.logger.debug 'LINE send'
    to = envelope.user.name
    @bot.send to, str for str in strings


  reply: (envelope, strings...) ->
    @robot.logger.debug 'LINE reply'
    to = envelope.user.name
    @bot.send to, str for str in strings


  emote: (envelope, actions...) ->
    @robot.logger.debug 'LINE emote'
    to = envelope.user.name
    @bot.emote to, act for act in actions


  run: ->
    self = @
    @robot.logger.debug 'LINE run'

    options =
      channelId:     process.env.HUBOT_LINE_CHANNEL_ID
      channelSecret: process.env.HUBOT_LINE_CHANNEL_SECRET
      channelMid:    process.env.HUBOT_LINE_CHANNEL_MID
      callbackPath:  process.env.HUBOT_LINE_CALLBACK_PATH or '/hubot/line/callback'
      proxy:         process.env.HUBOT_LINE_PROXY_URL or process.env.FIXIE_URL

    @lineHttpOptions =
      protocol: 'https:'
      hostname: 'trialbot-api.line.me'
      port:     443
      headers:
        'X-Line-ChannelID':             options.channelId
        'X-Line-ChannelSecret':         options.channelSecret
        'X-Line-Trusted-User-With-ACL': options.channelMid
    if options.proxy
      @lineHttpOptions.agent = new HttpsProxyAgent options.proxy

    bot = new LineStreaming(options, @robot)

    bot.on 'message', (from, id, contentType, contentMetadata, text, location) ->
      user = @robot.brain.userForId from
      switch contentType
        when 1
          @robot.logger.debug "LINE text message [#{text}] from [#{from}] id [#{id}]"
          self.receive new TextMessage user, text
        when 2
          @robot.logger.debug "LINE image message from [#{from}] id [#{id}] contentMetadata [#{JSON.stringify(contentMetadata)}]"
          self.receive new LineImageMessage user, @robot, id, contentType, contentMetadata
        when 3
          @robot.logger.debug "LINE video message from [#{from}] id [#{id}] contentMetadata [#{JSON.stringify(contentMetadata)}]"
          self.receive new LineVideoMessage user, @robot, id, contentType, contentMetadata
        when 4
          @robot.logger.debug "LINE audio message from [#{from}] id [#{id}] contentMetadata [#{JSON.stringify(contentMetadata)}]"
          self.receive new LineAudioMessage user, @robot, id, contentType, contentMetadata
        when 7
          @robot.logger.debug "LINE location message from [#{from}] id [#{id}] contentMetadata [#{JSON.stringify(contentMetadata)}] location [#{JSON.stringify(location)}]"
          self.receive new LineLocationMessage user, @robot, id, contentType, contentMetadata, location
        when 8
          @robot.logger.debug "LINE sticker message from [#{from}] id [#{id}] contentMetadata [#{JSON.stringify(contentMetadata)}]"
          self.receive new LineStickerMessage user, @robot, id, contentType, contentMetadata
        when 10
          @robot.logger.debug "LINE contact message from [#{from}] id [#{id}] contentMetadata [#{JSON.stringify(contentMetadata)}]"
          self.receive new LineContactMessage user, @robot, id, contentType, contentMetadata
        else
          @robot.logger.error "LINE unknown message [#{text}] from [#{from}] id [#{id}] contentType [#{contentType}] contentMetadata [#{JSON.stringify(contentMetadata)}] location [#{JSON.stringify(location)}]"
          self.receive new LineRawMessage user, @robot, id, contentType, contentMetadata, location

    bot.on 'operation', (opType, params) ->
      switch opType
        when 4
          @robot.logger.debug "LINE friend operation from [#{params}]"
          user = @robot.brain.userForId params[0]
          self.receive new LineFriendOperation user, opType, params
        when 8
          @robot.logger.debug "LINE block operation from [#{params}]"
          user = @robot.brain.userForId params[0]
          self.receive new LineBlockOperation user, opType, params
        else
          @robot.logger.error "LINE unknown operation opType [#{opType}] params[#{params}]"
          user = @robot.brain.userForId params[0]
          self.receive new LineRawOperation user, opType, params

    bot.listen()

    @bot = bot

    @emit 'connected'





class LineStreaming extends EventEmitter

  constructor: (options, @robot) ->
    @options = options


  send: (to, message) ->
    @robot.logger.debug "LINE send [#{message}] to [#{to}]"
    @_request to, new LineTextAction message


  emote: (to, action) ->
    if action instanceof LineAction
      @robot.logger.debug "LINE emote #{action.constructor.name} to [#{to}]"
      @_request to, action
    else
      @robot.logger.error "LINE emote is ignored. emote supports LineAction only. to [#{to}]"


  _request: (to, action) ->
    logger = @robot.logger
    body = JSON.stringify
      to:        [to]
      toChannel: 1383378250 # Fixed value
      eventType: "138311608800106203" # Fixed value
      content: action.requestParameters()
    body = body.replace /[\u0080-\uFFFF]/g, (match) ->
      if /[\u0080-\u00FF]/.test match
        # If code unit value is 0xFF or less it become a two-digit escape.
        escape(match).replace /%/g, "\\u00"
      else
        escape(match).replace /%u/g, "\\u"
    logger.debug "LINE _request body [#{body}]"

    @robot.http({}, @robot.adapter.lineHttpOptions)
      .path("/v1/events")
      .header('Content-Type', 'application/json')
      .post(body) (err, res, body) ->
        logger.debug "LINE _request response statusCode [#{res.statusCode}]"
        logger.debug "LINE _request response body [#{body}]"
        if err
          logger.error "LINE _request response error [#{err}]"


  listen: ->
    @robot.router.post @options.callbackPath, (request, response) =>
      @robot.logger.debug "LINE listen [#{JSON.stringify(request.body.result)}]"
      for result in request.body.result
        content = result.content
        if result.eventType is "138311609100106403" # Received operation
          @emit 'operation', content.opType, content.params
        else
          @emit 'message', content.from, content.id, content.contentType, content.contentMetadata, content.text, content.location
      response.send 'OK'





module.exports = LineAdapter
