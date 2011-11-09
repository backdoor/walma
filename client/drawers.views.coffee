
Backbone = require "backbone"

views = NS "PWB.drawers.views"


class views.ColorSelector extends Backbone.View

  option: "color"

  constructor: ->
    super

    # load default value
    if not @model.get @option
      options = {}
      options[@option] = @$("button.selected").data "value"
      @model.set options

    @update()

    @model.bind "change", @update
    @styleButtons()

  styleButtons: ->
    @$(".options button").each ->
      $el = $ this
      $el.css "background-color", $el.data "value"

  events:
    "tap .toggle": "openOptions"
    "tap .options button": "change"


  openOptions: =>
    @$(".options").animate width: "show", 150, =>
      $(window).one "tap", => @closeOptions()

  closeOptions: =>
    @$(".options").animate(width: "hide", 150)


  change: (e) =>
    setting = $(e.currentTarget)

    options = {}
    options[@option] = color = setting.data("value")
    @model.set options

    @$(".selected").removeClass "selected"
    setting.addClass "selected"


  update: =>
    @$("button.toggle").css "background-color", @model.get @option


class views.SizeSelector extends views.ColorSelector
  option: "size"
  styleButtons: ->
    @$(".options button").each ->
      $el = $ this
      $el.html "#{$el.data "value"}px"

  update: =>
    @$("button.toggle").html "#{ @model.get @option }px"

class views.ToolSelector extends views.ColorSelector
  option: "tool"
  styleButtons: ->

  update: =>
    @$("button.toggle").html "#{ @model.get @option }"


class views.Status extends Backbone.View

  constructor: ->
    super
    source = $(".status-template").html()
    @template = Handlebars.compile source
    @model.bind "change", => @render()

  render: ->
    $(@el).html @template @model.toJSON()


