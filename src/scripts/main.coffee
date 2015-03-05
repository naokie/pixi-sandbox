class Far extends PIXI.TilingSprite
  constructor: ->
    super

init = ->
  @stage = new PIXI.Stage 0x66FF99
  @renderer = PIXI.autoDetectRenderer 512, 384
  document.body.appendChild @renderer.view

  farTexture = PIXI.Texture.fromImage '../img/bg-far.png'
  @far = new Far farTexture, 512, 256
  @far.position.x = 0
  @far.position.y = 0
  @far.tilePosition.x = 0
  @far.tilePosition.y = 0
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
