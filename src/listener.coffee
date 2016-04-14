{Listener} = require 'hubot'
{LineRawMessage, LineImageMessage, LineVideoMessage, LineAudioMessage, LineLocationMessage, LineStickerMessage, LineContactMessage, LineRawOperation, LineFriendOperation, LineBlockOperation} = require './message'



class LineRawMessageListener extends Listener
  # LineRawMessageListeners receive LineRawMessages from the Line adapter and decide if they want to act on it.
  #
  # robot    - A Robot instance.
  # matcher  - A Function that determines if this listener should trigger the callback. The matcher takes a LineRawMessage.
  # callback - A Function that is triggered if the incoming message matches.
  #
  # To use this listener in your own script, you can say
  #
  #     robot.listeners.push new LineRawMessageListener(robot, matcher, callback)
  constructor: (@robot, @matcher, @callback) ->

  # Public: Determines if the listener likes the content of the message.
  call: (message, middleware, cb) ->
    if message instanceof LineRawMessage
      super message, middleware, cb
    else
      if cb?
        # No, we didn't try to execute the listener callback
        process.nextTick -> cb false
      false



class LineImageListener extends Listener
  # LineImageListeners receive LineImageMessages from the Line adapter and decide if they want to act on it.
  #
  # robot    - A Robot instance.
  # matcher  - A Function that determines if this listener should trigger the callback. The matcher takes a LineImageMessage.
  # callback - A Function that is triggered if the incoming message matches.
  #
  # To use this listener in your own script, you can say
  #
  #     robot.listeners.push new LineImageListener(robot, matcher, callback)
  constructor: (@robot, @matcher, @callback) ->

  # Public: Determines if the listener likes the content of the message.
  call: (message, middleware, cb) ->
    if message instanceof LineImageMessage
      super message, middleware, cb
    else
      if cb?
        # No, we didn't try to execute the listener callback
        process.nextTick -> cb false
      false



class LineVideoListener extends Listener
  # LineVideoListeners receive LineVideoMessages from the Line adapter and decide if they want to act on it.
  #
  # robot    - A Robot instance.
  # matcher  - A Function that determines if this listener should trigger the callback. The matcher takes a LineVideoMessage.
  # callback - A Function that is triggered if the incoming message matches.
  #
  # To use this listener in your own script, you can say
  #
  #     robot.listeners.push new LineVideoListener(robot, matcher, callback)
  constructor: (@robot, @matcher, @callback) ->

  # Public: Determines if the listener likes the content of the message.
  call: (message, middleware, cb) ->
    if message instanceof LineVideoMessage
      super message, middleware, cb
    else
      if cb?
        # No, we didn't try to execute the listener callback
        process.nextTick -> cb false
      false



class LineAudioListener extends Listener
  # LineAudioListeners receive LineAudioMessages from the Line adapter and decide if they want to act on it.
  #
  # robot    - A Robot instance.
  # matcher  - A Function that determines if this listener should trigger the callback. The matcher takes a LineAudioMessage.
  # callback - A Function that is triggered if the incoming message matches.
  #
  # To use this listener in your own script, you can say
  #
  #     robot.listeners.push new LineAudioListener(robot, matcher, callback)
  constructor: (@robot, @matcher, @callback) ->

  # Public: Determines if the listener likes the content of the message.
  call: (message, middleware, cb) ->
    if message instanceof LineAudioMessage
      super message, middleware, cb
    else
      if cb?
        # No, we didn't try to execute the listener callback
        process.nextTick -> cb false
      false



class LineLocationListener extends Listener
  # LineLocationListeners receive LineLocationMessages from the Line adapter and decide if they want to act on it.
  #
  # robot    - A Robot instance.
  # matcher  - A Function that determines if this listener should trigger the callback. The matcher takes a LineLocationMessage.
  # callback - A Function that is triggered if the incoming message matches.
  #
  # To use this listener in your own script, you can say
  #
  #     robot.listeners.push new LineLocationListener(robot, matcher, callback)
  constructor: (@robot, @matcher, @callback) ->

  # Public: Determines if the listener likes the content of the message.
  call: (message, middleware, cb) ->
    if message instanceof LineLocationMessage
      super message, middleware, cb
    else
      if cb?
        # No, we didn't try to execute the listener callback
        process.nextTick -> cb false
      false



class LineStickerListener extends Listener
  # LineStickerListeners receive LineStickerMessages from the Line adapter and decide if they want to act on it.
  #
  # robot    - A Robot instance.
  # matcher  - A Function that determines if this listener should trigger the callback. The matcher takes a LineStickerMessage.
  # callback - A Function that is triggered if the incoming message matches.
  #
  # To use this listener in your own script, you can say
  #
  #     robot.listeners.push new LineStickerListener(robot, matcher, callback)
  constructor: (@robot, @matcher, @callback) ->

  # Public: Determines if the listener likes the content of the message.
  call: (message, middleware, cb) ->
    if message instanceof LineStickerMessage
      super message, middleware, cb
    else
      if cb?
        # No, we didn't try to execute the listener callback
        process.nextTick -> cb false
      false



class LineContactListener extends Listener
  # LineContactListeners receive LineContactMessages from the Line adapter and decide if they want to act on it.
  #
  # robot    - A Robot instance.
  # matcher  - A Function that determines if this listener should trigger the callback. The matcher takes a LineContactMessage.
  # callback - A Function that is triggered if the incoming message matches.
  #
  # To use this listener in your own script, you can say
  #
  #     robot.listeners.push new LineContactListener(robot, matcher, callback)
  constructor: (@robot, @matcher, @callback) ->

  # Public: Determines if the listener likes the content of the message.
  call: (message, middleware, cb) ->
    if message instanceof LineContactMessage
      super message, middleware, cb
    else
      if cb?
        # No, we didn't try to execute the listener callback
        process.nextTick -> cb false
      false





class LineRawOperationListener extends Listener
  # LineRawOperationListeners receive LineRawOperationMessages from the Line adapter and decide if they want to act on it.
  #
  # robot    - A Robot instance.
  # matcher  - A Function that determines if this listener should trigger the callback. The matcher takes a LineRawOperationMessage.
  # callback - A Function that is triggered if the incoming message matches.
  #
  # To use this listener in your own script, you can say
  #
  #     robot.listeners.push new LineRawOperationListener(robot, matcher, callback)
  constructor: (@robot, @matcher, @callback) ->

  # Public: Determines if the listener likes the content of the message.
  call: (message, middleware, cb) ->
    if message instanceof LineRawOperation
      super message, middleware, cb
    else
      if cb?
        # No, we didn't try to execute the listener callback
        process.nextTick -> cb false
      false



class LineFriendListener extends Listener
  # LineFriendListeners receive LineFriendMessages from the Line adapter and decide if they want to act on it.
  #
  # robot    - A Robot instance.
  # matcher  - A Function that determines if this listener should trigger the callback. The matcher takes a LineFriendMessage.
  # callback - A Function that is triggered if the incoming message matches.
  #
  # To use this listener in your own script, you can say
  #
  #     robot.listeners.push new LineFriendListener(robot, matcher, callback)
  constructor: (@robot, @matcher, @callback) ->

  # Public: Determines if the listener likes the content of the message.
  call: (message, middleware, cb) ->
    if message instanceof LineFriendOperation
      super message, middleware, cb
    else
      if cb?
        # No, we didn't try to execute the listener callback
        process.nextTick -> cb false
      false



class LineBlockListener extends Listener
  # LineBlockListeners receive LineBlockMessages from the Line adapter and decide if they want to act on it.
  #
  # robot    - A Robot instance.
  # matcher  - A Function that determines if this listener should trigger the callback. The matcher takes a LineBlockMessage.
  # callback - A Function that is triggered if the incoming message matches.
  #
  # To use this listener in your own script, you can say
  #
  #     robot.listeners.push new LineBlockListener(robot, matcher, callback)
  constructor: (@robot, @matcher, @callback) ->

  # Public: Determines if the listener likes the content of the message.
  call: (message, middleware, cb) ->
    if message instanceof LineBlockOperation
      super message, middleware, cb
    else
      if cb?
        # No, we didn't try to execute the listener callback
        process.nextTick -> cb false
      false



module.exports = {
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
}
