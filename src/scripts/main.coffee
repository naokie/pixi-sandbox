class Far extends PIXI.TilingSprite
  constructor: ->
    texture = PIXI.Texture.fromImage '../img/bg-far.png'
    super texture, 512, 256
    @position.x = 0
    @position.y = 0
    @tilePosition.x = 0
    @tilePosition.y = 0

  update: ->
    @tilePosition.x -= 0.128

class Mid extends PIXI.TilingSprite
  constructor: ->
    texture = PIXI.Texture.fromImage '../img/bg-mid.png'
    super texture, 512, 256
    @position.x = 0
    @position.y = 128
    @tilePosition.x = 0
    @tilePosition.y = 0

  update: ->
    @tilePosition.x -= 0.64

init = ->
  @stage = new PIXI.Stage 0x66FF99
  @renderer = PIXI.autoDetectRenderer 512, 384
  document.body.appendChild @renderer.view

  @far = new Far
  @stage.addChild @far

  @mid = new Mid
  @stage.addChild @mid

  requestAnimFrame update

update = ->
  @far.update()
  @mid.update()

  @renderer.render @stage
  requestAnimFrame update

$ ->
  init()
