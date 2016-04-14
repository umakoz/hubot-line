{Message} = require 'hubot'



# Hubot only started exporting Message in 2.11.0. Previous version do not export
# this class. In order to remain compatible with older versions, we can pull the
# Message class from TextMessage superclass.
if not Message
  Message = TextMessage.__super__.constructor



class LineRawMessage extends Message
  # Represents LINE messages that are not suitable to treat as text messages.
  #
  # user            - The User object.
  # id              - Identifier of the message.
  # contentType     - A numeric value indicating the type of message sent.
  # contentMetadata - Detailed information about the message.
  # location        - Location data. This property is defined if the text message sent contains location data.
  constructor: (@user, @id, @contentType, @contentMetadata, @location) ->
    super @user



class LineImageMessage extends LineRawMessage
  # LINE image message
  #
  # user            - The User object.
  # id              - Identifier of the message.
  # contentType     - A numeric value indicating the type of message sent.
  # contentMetadata - Detailed information about the message.
  # location        - Location data. This property is defined if the text message sent contains location data.
  constructor: (@user, @id, @contentType, @contentMetadata, @location = "") ->



class LineVideoMessage extends LineRawMessage
  # LINE video message
  #
  # user            - The User object.
  # id              - Identifier of the message.
  # contentType     - A numeric value indicating the type of message sent.
  # contentMetadata - Detailed information about the message.
  # location        - Location data. This property is defined if the text message sent contains location data.
  constructor: (@user, @id, @contentType, @contentMetadata, @location = "") ->



class LineAudioMessage extends LineRawMessage
  # LINE audio message
  #
  # user            - The User object.
  # id              - Identifier of the message.
  # contentType     - A numeric value indicating the type of message sent.
  # contentMetadata - Detailed information about the message.
  # location        - Location data. This property is defined if the text message sent contains location data.
  constructor: (@user, @id, @contentType, @contentMetadata, @location = "") ->



class LineLocationMessage extends LineRawMessage
  # LINE location message
  #
  # user            - The User object.
  # id              - Identifier of the message.
  # contentType     - A numeric value indicating the type of message sent.
  # contentMetadata - Detailed information about the message.
  # location        - Location data. This property is defined if the text message sent contains location data.
  constructor: (@user, @id, @contentType, @contentMetadata, @location) ->
    @title = @location.title
    @address = @location.address
    @latitude = @location.latitude
    @longitude = @location.longitude
    super @user, @id, @contentType, @contentMetadata, @location



class LineStickerMessage extends LineRawMessage
  # LINE sticker message
  #
  # user            - The User object.
  # id              - Identifier of the message.
  # contentType     - A numeric value indicating the type of message sent.
  # contentMetadata - Detailed information about the message.
  # location        - Location data. This property is defined if the text message sent contains location data.
  constructor: (@user, @id, @contentType, @contentMetadata, @location = "") ->
    @STKPKGID = @contentMetadata.STKPKGID
    @STKID = @contentMetadata.STKID
    @STKVER = @contentMetadata.STKVER
    @STKTXT = @contentMetadata.STKTXT
    super @user, @id, @contentType, @contentMetadata, @location



class LineContactMessage extends LineRawMessage
  # LINE contact message
  #
  # user            - The User object.
  # id              - Identifier of the message.
  # contentType     - A numeric value indicating the type of message sent.
  # contentMetadata - Detailed information about the message.
  # location        - Location data. This property is defined if the text message sent contains location data.
  constructor: (@user, @id, @contentType, @contentMetadata, @location = "") ->
    @mid = @contentMetadata.mid
    @displayName = @contentMetadata.displayName
    super @user, @id, @contentType, @contentMetadata, @location





class LineRawOperation extends Message
  # Represents LINE operations that are not suitable to treat as text messages.
  #
  # user   - The User object.
  # opType - Type of operation
  # params - Array of MIDs
  constructor: (@user, @opType, @params) ->
    super @user



class LineFriendOperation extends LineRawOperation
  # LINE friend operation
  #
  # user   - The User object.
  # opType - Type of operation
  # params - Array of MIDs
  constructor: (@user, @opType, @params) ->
    @mid = @params[0]
    super @user, @opType, @params



class LineBlockOperation extends LineRawOperation
  # LINE block operation
  #
  # user   - The User object.
  # opType - Type of operation
  # params - Array of MIDs
  constructor: (@user, @opType, @params) ->
    @mid = @params[0]
    super @user, @opType, @params



module.exports = {
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
}
