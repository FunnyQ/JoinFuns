# *************************************
#
#   application.js
#
#
# *************************************
#= require _plugins
#= require _app-base

JoinFuns.initialMap = ->

  handler = Gmaps.build('Google')

  displayOnMap = (position) ->
    marker = handler.addMarker(
      lat: position.coords.latitude
      lng: position.coords.longitude)
    handler.map.centerOn marker
    return

  handler.buildMap {
      internal: id: 'map'
      provider: {
        zoom: 15,
        center: (lat: 25.060671, lng: 121.5313468)
      }
    }, ->
    if navigator.geolocation
      navigator.geolocation.getCurrentPosition(displayOnMap)
      return
    return
