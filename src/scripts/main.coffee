class Far extends PIXI.TilingSprite
  constructor: ->
    texture = PIXI.Texture.fromImage '../img/bg-far.png'
    super texture, 512, 256
    @position.x = 0
    @position.y = 0
    @tilePosition.x = 0
    @tilePosition.y = 0

init = ->
  @stage = new PIXI.Stage 0x66FF99
  @renderer = PIXI.autoDetectRenderer 512, 384
  document.body.appendChild @renderer.view

  @far = new Far
  @stage.addChild @far

  midTexture = PIXI.Texture.fromImage '../img/bg-mid.png'
  @mid = new PIXI.TilingSprite midTexture, 512, 256
  @mid.position.x = 0
  @mid.position.y = 128
  @mid.tilePosition.x = 0
  @mid.tilePosition.y = 0
  @stage.addChild @mid

  requestAnimFrame update

update = ->
  @far.tilePosition.x -= 0.128
  @mid.tilePosition.x -= 0.64

  @renderer.render @stage
  requestAnimFrame update

$ ->
  init()
