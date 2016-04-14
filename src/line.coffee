{Robot, Adapter, TextMessage} = require 'hubot'
Https = require 'https'
HttpsProxyAgent = require 'https-proxy-agent'
{EventEmitter} = require 'events'
{LineRawMessage, LineImageMessage, LineVideoMessage, LineAudioMessage, LineLocationMessage, LineStickerMessage, LineContactMessage, LineRawOperation, LineFriendOperation, LineBlockOperation} = require './message'



class LineAdapter extends Adapter

  send: (envelope, strings...) ->
    @robot.logger.debug 'LINE send'
    to = envelope.user.name
    @bot.send to, str for str in strings


  reply: (envelope, strings...) ->
    @robot.logger.debug 'LINE reply'
    to = envelope.user.name
    @bot.send to, str for str in strings


  run: ->
    self = @
    @robot.logger.debug 'LINE run'

    options =
      channel_id:     process.env.HUBOT_LINE_CHANNEL_ID
      channel_secret: process.env.HUBOT_LINE_CHANNEL_SECRET
      channel_mid:    process.env.HUBOT_LINE_CHANNEL_MID
      callback_path:  process.env.HUBOT_LINE_CALLBACK_PATH or '/hubot/line/callback'
      proxy:          process.env.HUBOT_LINE_PROXY_URL or process.env.FIXIE_URL

    bot = new LineStreaming(options, @robot)

    bot.on 'message', (from, id, contentType, contentMetadata, text, location) ->
      user = @robot.brain.userForId from
      switch contentType
        when 1
          @robot.logger.debug "LINE text message [#{text}] from [#{from}] id [#{id}]"
          self.receive new TextMessage user, text
        when 2
          @robot.logger.debug "LINE image message from [#{from}] id [#{id}] contentMetadata [#{JSON.stringify(contentMetadata)}]"
          self.receive new LineImageMessage user, id, contentType, contentMetadata
        when 3
          @robot.logger.debug "LINE video message from [#{from}] id [#{id}] contentMetadata [#{JSON.stringify(contentMetadata)}]"
          self.receive new LineVideoMessage user, id, contentType, contentMetadata
        when 4
          @robot.logger.debug "LINE audio message from [#{from}] id [#{id}] contentMetadata [#{JSON.stringify(contentMetadata)}]"
          self.receive new LineAudioMessage user, id, contentType, contentMetadata
        when 7
          @robot.logger.debug "LINE location message from [#{from}] id [#{id}] contentMetadata [#{JSON.stringify(contentMetadata)}] location [#{JSON.stringify(location)}]"
          self.receive new LineLocationMessage user, id, contentType, contentMetadata, location
        when 8
          @robot.logger.debug "LINE sticker message from [#{from}] id [#{id}] contentMetadata [#{JSON.stringify(contentMetadata)}]"
          self.receive new LineStickerMessage user, id, contentType, contentMetadata
        when 10
          @robot.logger.debug "LINE contact message from [#{from}] id [#{id}] contentMetadata [#{JSON.stringify(contentMetadata)}]"
          self.receive new LineContactMessage user, id, contentType, contentMetadata
        else
          @robot.logger.error "LINE unknown message [#{text}] from [#{from}] id [#{id}] contentType [#{contentType}] contentMetadata [#{JSON.stringify(contentMetadata)}] location [#{JSON.stringify(location)}]"
          self.receive new LineRawMessage user, id, contentType, contentMetadata, location

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
    logger = @robot.logger
    logger.debug "LINE send [#{message}] to [#{to}]"

    body = JSON.stringify
      to:        [to]
      toChannel: 1383378250 # Fixed value
      eventType: "138311608800106203" # Fixed value
      content:
        contentType: 1
        toType:      1
        text:        message
    logger.debug "LINE send body [#{body}]"

    headers =
      'User-Agent':     "Hubot/#{@robot?.version} (#{@robot?.name})"
      'Content-Type':   'application/json; charset=UTF-8'
      'Content-Length': body.length
      'X-Line-ChannelID':             @options.channel_id
      'X-Line-ChannelSecret':         @options.channel_secret
      'X-Line-Trusted-User-With-ACL': @options.channel_mid

    opts =
      host:    'trialbot-api.line.me'
      port:    443
      path:    '/v1/events'
      method:  'POST'
      headers: headers

    if @options.proxy
      opts.agent = new HttpsProxyAgent @options.proxy

    logger.debug "LINE send opts [#{JSON.stringify(opts)}]"

    request = Https.request opts, (response) ->
      response.setEncoding('utf8')
      logger.debug "LINE response statusCode [#{response.statusCode}]"

      buffer = ''
      response.on 'data', (data) ->
        logger.debug "LINE response data [#{data}]"

      response.on 'end', () ->
        logger.debug "LINE response end"

      response.on 'error', (error) ->
        logger.error "LINE send response error [#{error}]"

    request.on 'error', (error) ->
      logger.error "LINE send request error [#{error}]"

    request.end(body)


  listen: ->
    @robot.router.post @options.callback_path, (request, response) =>
      @robot.logger.debug "LINE listen [#{JSON.stringify(request.body.result)}]"
      for result in request.body.result
        content = result.content
        if result.eventType is "138311609100106403" # Received operation
          @emit 'operation', content.opType, content.params
        else
          @emit 'message', content.from, content.id, content.contentType, content.contentMetadata, content.text, content.location
      response.send 'OK'





module.exports = LineAdapter
