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
    @createFrontEdges()
    @createBackEdges()
    @createSteps()

  borrowWindow: ->
    @windows.shift()

  returnWindow: (sprite) ->
    @windows.push sprite

  borrowDecoration: ->
    @decorations.shift()

  returnDecoration: (sprite) ->
    @decorations.push sprite

  borrowFrontEdge: ->
    @frontEdges.shift()

  returnFrontEdge: (sprite) ->
    @frontEdges.push sprite

  borrowBackEdge: ->
    @backEdges.shift()

  returnBackEdge: (sprite) ->
    @backEdges.push sprite

  borrowStep: ->
    @steps.shift()

  returnStep: (sprite) ->
    @steps.push sprite

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

  createFrontEdges: ->
    @frontEdges = []

    @addFrontEdgeSprites 2, 'edge_01'
    @addFrontEdgeSprites 2, 'edge_02'

    @shuffle @frontEdges

  createBackEdges: ->
    @backEdges = []

    @addBackEdgeSprites 2, 'edge_01'
    @addBackEdgeSprites 2, 'edge_02'

    @shuffle @backEdges

  createSteps: ->
    @steps = []
    @addStepSprites 2, 'step_01'

  addWindowSprites: (amount, frameId) ->
    for i in [0...amount]
      sprite = new PIXI.Sprite PIXI.Texture.fromFrame frameId
      @windows.push sprite

  addDecorationSprites: (amount, frameId) ->
    for i in [0...amount]
      sprite = new PIXI.Sprite PIXI.Texture.fromFrame frameId
      @decorations.push sprite

  addFrontEdgeSprites: (amount, frameId) ->
    for i in [0...amount]
      sprite = new PIXI.Sprite PIXI.Texture.fromFrame frameId
      @frontEdges.push sprite

  addBackEdgeSprites: (amount, frameId) ->
    for i in [0...amount]
      sprite = new PIXI.Sprite PIXI.Texture.fromFrame frameId
      sprite.anchor.x = 1
      sprite.scale.x = -1
      @backEdges.push sprite

  addStepSprites: (amount, frameId) ->
    for i in [0...amount]
      sprite = new PIXI.Sprite PIXI.Texture.fromFrame frameId
      sprite.anchor.y = 0.25
      @steps.push sprite

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

  generateTestWallSpan: ->
    lookupTable = [
      @pool.borrowFrontEdge
      @pool.borrowWindow
      @pool.borrowDecoration
      @pool.borrowStep
      @pool.borrowWindow
      @pool.borrowBackEdge
    ]

    yPos = [
      128
      128
      128
      192
      192
      192
    ]

    for borrowFunc, i in lookupTable
      sprite = borrowFunc.call @pool
      sprite.position.x = 64 + (i * 64)
      sprite.position.y = yPos[i]

      @wallSlices.push sprite
      @stage.addChild sprite

  clearTestWallSpan: ->
    lookupTable = [
      @pool.returnFrontEdge
      @pool.returnWindow
      @pool.returnDecoration
      @pool.returnStep
      @pool.returnWindow
      @pool.returnBackEdge
    ]

    for returnFunc, i in lookupTable
      sprite = @wallSlices[i]
      @stage.removeChild sprite
      returnFunc.call @pool, sprite

    @wallSlices = []


$ ->
  main = new Main
