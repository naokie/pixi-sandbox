class Far extends PIXI.TilingSprite
  DELTA_X = 0.128

  constructor: ->
    texture = PIXI.Texture.fromImage '../img/bg-far.png'
    super texture, 512, 256
    @position.x = 0
    @position.y = 0
    @tilePosition.x = 0
    @tilePosition.y = 0
    @viewportX = 0

  setViewportX: (newViewportX) ->
    distanceTravelled = newViewportX - @viewportX
    @viewportX = newViewportX
    @tilePosition.x -= (distanceTravelled * DELTA_X)


class Mid extends PIXI.TilingSprite
  DELTA_X = 0.64

  constructor: ->
    texture = PIXI.Texture.fromImage '../img/bg-mid.png'
    super texture, 512, 256
    @position.x = 0
    @position.y = 128
    @tilePosition.x = 0
    @tilePosition.y = 0
    @viewportX = 0

  setViewportX: (newViewportX) ->
    distanceTravelled = newViewportX - @viewportX
    @viewportX = newViewportX
    @tilePosition.x -= (distanceTravelled * DELTA_X)


class Scroller
  constructor: (stage) ->
    @far = new Far
    stage.addChild @far

    @mid = new Mid
    stage.addChild @mid

    @viewportX = 0

  setViewportX: (viewportX) ->
    @viewportX = viewportX
    @far.setViewportX viewportX
    @mid.setViewportX viewportX

  getViewportX: ->
    @viewportX

  moveViewportXBy: (units) ->
    newViewportX = @viewportX + units
    @setViewportX newViewportX


class Main
  SCROLL_SPEED = 5

  constructor: ->
    @stage = new PIXI.Stage 0x66FF99
    @renderer = PIXI.autoDetectRenderer 512, 384
    document.body.appendChild @renderer.view

    @scroller = new Scroller @stage

    requestAnimFrame @update

  update: =>
    @scroller.moveViewportXBy SCROLL_SPEED

    @renderer.render @stage
    requestAnimFrame @update


$ ->
  main = new Main
