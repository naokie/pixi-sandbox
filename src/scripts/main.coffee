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


class WallSpritesPool
  constructor: ->
    @createWindows()
    @createDecorations()

  borrowWindow: ->
    @windows.shift()

  returnWindow: (sprite) ->
    @windows.push sprite

  borrowDecoration: ->
    @decorations.shift()

  returnDecoration: (sprite) ->
    @decorations.push sprite

  createWindows: ->
    @windows = []

    @addWindowSprites 6, 'window_01'
    @addWindowSprites 6, 'window_02'

    @shuffle @windows

  createDecorations: () ->
    @decorations = []

    @addDecorationSprites 6, 'decoration_01'
    @addDecorationSprites 6, 'decoration_02'
    @addDecorationSprites 6, 'decoration_03'

    @shuffle @decorations

  addWindowSprites: (amount, frameId) ->
    for i in [0...amount]
      sprite = new PIXI.Sprite PIXI.Texture.fromFrame frameId
      @windows.push sprite

  addDecorationSprites: (amount, frameId) ->
    for i in [0...amount]
      sprite = new PIXI.Sprite PIXI.Texture.fromFrame frameId
      @decorations.push sprite

  shuffle: (array) ->
    len = array.length
    shuffles = len * 3

    for i in [0...shuffles]
      wallSlice = array.pop()
      pos = Math.floor Math.random() * (len - 1)
      array.splice pos, 0, wallSlice


class Main
  SCROLL_SPEED = 5

  constructor: ->
    @stage = new PIXI.Stage 0x66FF99
    @renderer = PIXI.autoDetectRenderer 512, 384
    document.body.appendChild @renderer.view

    @loadSpriteSheet()

  update: =>
    @scroller.moveViewportXBy SCROLL_SPEED

    @renderer.render @stage
    requestAnimFrame @update

  loadSpriteSheet: ->
    assetsToLoad = [
      "img/wall.json"
      "img/bg-mid.png"
      "img/bg-far.png"
    ]
    loader = new PIXI.AssetLoader assetsToLoad
    loader.onComplete = @spriteSheetLoaded
    loader.load()

  spriteSheetLoaded: =>
    @scroller = new Scroller @stage
    requestAnimFrame @update

    @pool = new WallSpritesPool
    @wallSlices = []

  borrowWallSprites: (num) ->
    for i in [0...num]
      if i % 2 is 0
        sprite = @pool.borrowWindow()
      else
        sprite = @pool.borrowDecoration()

      sprite.position.x = -32 + (i * 64)
      sprite.position.y = 128

      @wallSlices.push sprite
      @stage.addChild sprite

  returnWallSprites: ->
    for sprite, i in @wallSlices
      @stage.removeChild sprite
      if i % 2 is 0
        @pool.returnWindow sprite
      else
        @pool.returnDecoration sprite


$ ->
  main = new Main
