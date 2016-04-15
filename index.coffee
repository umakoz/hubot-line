LineAdapter = require './src/line'
{LineRawMessage, LineImageMessage, LineVideoMessage, LineAudioMessage, LineLocationMessage, LineStickerMessage, LineContactMessage, LineRawOperation, LineFriendOperation, LineBlockOperation} = require './src/message'
{LineRawMessageListener, LineImageListener, LineVideoListener, LineAudioListener, LineLocationListener, LineStickerListener, LineContactListener, LineRawOperationListener, LineFriendListener, LineBlockListener} = require './src/listener'
{LineTextAction, LineImageAction, LineVideoAction, LineAudioAction, LineLocationAction, LineStickerAction} = require './src/action'

module.exports = exports = {
  LineAdapter

  LineRawMessage
  LineImageMessage
  LineVideoMessage
  LineAudioMessage
  LineLocationMessage
  LineStickerMessage
  LineContactMessage

  LineRawOperation
  LineFriendOperation
  LineBlockOperation

  LineRawMessageListener
  LineImageListener
  LineVideoListener
  LineAudioListener
  LineLocationListener
  LineStickerListener
  LineContactListener

  LineRawOperationListener
  LineFriendListener
  LineBlockListener

  LineTextAction
  LineImageAction
  LineVideoAction
  LineAudioAction
  LineLocationAction
  LineStickerAction
}

exports.use = (robot) ->
  new LineAdapter robot
