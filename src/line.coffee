{Robot, Adapter, TextMessage} = require 'hubot'
Https = require 'https'
HttpsProxyAgent = require 'https-proxy-agent'
{EventEmitter} = require 'events'



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

    bot.on 'message', (mid, message) ->
      @robot.logger.debug "LINE message #{message} from #{mid}"
      user = @robot.brain.userForId mid
      self.receive new TextMessage user, message

    bot.listen()

    @bot = bot

    @emit 'connected'



exports.use = (robot) ->
  new LineAdapter robot





class LineStreaming extends EventEmitter

  constructor: (options, @robot) ->
    @options = options


  send: (to, message) ->
    logger = @robot.logger
    logger.debug "LINE send #{message} to #{to}"

    body = JSON.stringify
      to:        [to]
      toChannel: 1383378250 # Fixed value
      eventType: "138311608800106203" # Fixed value
      content:
        contentType: 1
        toType:      1
        text:        message
    logger.debug "LINE send body #{body}"

    headers =
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

    logger.debug "LINE send opts #{JSON.stringify(opts)}"

    request = Https.request opts, (response) ->
      response.setEncoding('utf8')
      logger.debug "LINE response statusCode: #{response.statusCode}"

      buffer = ''
      response.on 'data', (data) ->
        logger.debug "LINE response data: #{data}"

      response.on 'end', () ->
        logger.debug "LINE response end"

      response.on 'error', (error) ->
        logger.error "LINE send response error: #{error}"

    request.on 'error', (error) ->
      logger.error "LINE send request error: #{error}"

    request.end(body)


  listen: ->
    @robot.router.post @options.callback_path, (request, response) =>
      for result in request.body.result
        mid = result.content.from
        message = result.content.text
        @robot.logger.debug "LINE listen #{message} from #{mid}"
        @emit 'message', mid, message
      response.send 'OK'

