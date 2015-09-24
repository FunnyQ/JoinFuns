# *************************************
#
#   application.js
#
#
# *************************************
#= require _plugins
#= require _app-base


JoinFuns.renderCreatedEventMarker = ->
  class CustomMarkerBuilder extends Gmaps.Google.Builders.Marker
    create_marker: ->
      options = _.extend @marker_options(), @rich_marker_options()
      @serviceObject = new RichMarker options

    rich_marker_options: ->
      marker = document.createElement("div")
      marker.setAttribute('class', 'custom_marker_content')
      marker.innerHTML = this.args.custom_marker
      { content: marker }

    create_infowindow: ->
      return null unless _.isString @args.custom_infowindow

      boxText = document.createElement("div")
      boxText.setAttribute("class", 'custom_infowindow_content')
      boxText.innerHTML = @args.custom_infowindow
      @infowindow = new InfoBox(@infobox(boxText))

    infobox: (boxText)->
      content: boxText
      pixelOffset: new google.maps.Size(-140, 0)
      boxStyle:
        width: "280px"

  handler = Gmaps.build('Google', builders: { Marker: CustomMarkerBuilder })

  handler.buildMap {
       internal: id: 'map'
       provider: {
          zoom: 15,
          center: (lat: 25.060671, lng: 121.5313468)
        }
  }, ->
    markers = handler.addMarkers([
      {
        lat: gon.sticker[0]
        lng: gon.sticker[1]
        custom_marker:"<div class=event-demo></div>"

      }
    ])

    handler.bounds.extendWith markers
    handler.fitMapToBounds()

    return


JoinFuns.initialMap = ->

  handler = Gmaps.build('Google')

  displayOnMap = (position) ->
    markers = handler.addMarker([
      {
        lat: position.coords.latitude
        lng: position.coords.longitude
      }
    ])

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


JoinFuns.initMaterialSelect = ->
  $('select').material_select()
  $(".dropdown-button").dropdown()

JoinFuns.initMaterialDatepicker = ->
  $('.datepicker').pickadate
    selectMonths: true
    selectYears: 15

class JoinFuns.FilterPanel
  constructor: ->
    @trigger = $('[data-behavior="filter-trigger"]')
    @icon = @trigger.find('[data-behavior="icon"]')
    @panel = $('[data-behavior="filter-panel"]')
    @setEvent() # 立即執行

  setEvent: ->
    @trigger.on 'click', @togglePanel

  togglePanel: =>
    return @hidePanel() if @panel.hasClass('actived')
    @showPanel()

  hidePanel: ->
    @panel.removeClass 'actived'
    @icon.removeClass 'fa-angle-left'
    @icon.addClass 'fa-angle-right'
    @panel.find('form')[0].reset()

  showPanel: ->
    @panel.addClass 'actived'
    @icon.removeClass 'fa-angle-right'
    @icon.addClass 'fa-angle-left'

class JoinFuns.Notifiers
  constructor: ->
    @notifierWrapper = $('[data-behavior="notifiers-wrapper"]')
    @notifiers = $.map $('[data-behavior="notifier"]'), (notifier) ->
      new Notifier(notifier)

  class Notifier
    constructor: (notifier) ->
      @notifier = $(notifier)
      @tagsWrapper = @notifier.find('[data-behavior="prices-wrapper"]')
      @priceTags = $.map @tagsWrapper.find('[data-behavior="price-tag"]'), (priceTag) =>
        new PriceTag(priceTag, @tagsWrapper)
      @setEvent()

    setEvent: ->
      @notifier.on 'click', '[data-behavior="close-btn"]', @hideNotifier

    hideNotifier: =>
      @notifier.fadeOut()

  class PriceTag
    constructor: (priceTag, priceTagsWrapper) ->
      @priceTagsWrapper = $(priceTagsWrapper)
      @priceTag = $(priceTag)
      @price = @priceTag.find('.value').text()
      # @inputField = @priceTagsWrapper.find('[data-behavior="input"]')
      @setEvent()

    setEvent: ->
      @priceTag.on 'click', @setPrice

    setPrice: =>
      @priceTagsWrapper.find('.actived').removeClass('actived')
      @priceTag.addClass('actived')
      # TODO: put @price into @inputField
