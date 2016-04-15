# Refer to https://developers.line.me/bot-api/api-reference#sending_message

class LineAction
  # Represents LINE actions that request to the LINE platform.
  #
  # contentType - Type of content.
  constructor: (@contentType) ->
    @toType = 1 # Type of recipient set in the to property. (1 = user)

  requestParameters: -> {}



class LineTextAction extends LineAction
  # LINE text action
  #
  # text - String you want to send. Messages can contain up to 1024 characters.
  constructor: (@text) ->
    super 1

  requestParameters: ->
    contentType: @contentType
    toType: @toType
    text: @text



class LineImageAction extends LineAction
  # LINE image action
  #
  # originalContentUrl - URL of image. Only JPEG format supported. Image size cannot be larger than 1024×1024.
  # previewImageUrl - URL of thumbnail image. For preview. Only JPEG format supported. Image size cannot be larger than 240×240.
  constructor: (@originalContentUrl, @previewImageUrl) ->
    super 2

  requestParameters: ->
    contentType: @contentType
    toType: @toType
    originalContentUrl: @originalContentUrl
    previewImageUrl: @previewImageUrl



class LineVideoAction extends LineAction
  # LINE video action
  #
  # originalContentUrl - URL of the movie. The “mp4” format is recommended.
  # previewImageUrl - URL of thumbnail image used as a preview.
  constructor: (@originalContentUrl, @previewImageUrl) ->
    super 3

  requestParameters: ->
    contentType: @contentType
    toType: @toType
    originalContentUrl: @originalContentUrl
    previewImageUrl: @previewImageUrl



class LineAudioAction extends LineAction
  # LINE audio action
  #
  # originaloriginalContentUrl - URL of audio file. The “m4a” format is recommended.
  # AUDLEN - Length of voice message. The unit is given in milliseconds.
  constructor: (@originalContentUrl, @AUDLEN) ->
    super 4

  requestParameters: ->
    contentType: @contentType
    toType: @toType
    originalContentUrl: @originalContentUrl
    contentMetadata:
      AUDLEN: @AUDLEN



class LineLocationAction extends LineAction
  # LINE location action
  #
  # title - String used to explain the location information (example: name of restaurant, address).
  # latitude - Latitude
  # longitude - Longitude
  constructor: (@title, @latitude, @longitude) ->
    super 7

  requestParameters: ->
    contentType: @contentType
    toType: @toType
    text: @title
    location:
      title: @title
      latitude: @latitude
      longitude: @longitude



class LineStickerAction extends LineAction
  # LINE sticker action
  # STKID - ID of the sticker.
  # STKPKGID - Package ID of the sticker.
  # STKVER - Optional. Version number of the sticker. If omitted, the latest version number is applied.
  constructor: (@STKID, @STKPKGID, @STKVER = "") ->
    super 8

  requestParameters: ->
    contentType: @contentType
    toType: @toType
    contentMetadata:
      STKID: @STKID
      STKPKGID: @STKPKGID
      STKVER: @STKVER



module.exports = {
  LineAction
  LineTextAction
  LineImageAction
  LineVideoAction
  LineAudioAction
  LineLocationAction
  LineStickerAction
}
