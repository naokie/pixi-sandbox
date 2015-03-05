init = ->
  @stage = new PIXI.Stage 0x66FF99
  @renderer = PIXI.autoDetectRenderer 512, 384
  document.body.appendChild @renderer.view

  farTexture = PIXI.Texture.fromImage '../img/bg-far.png'
  @far = new PIXI.Sprite farTexture
  @far.position.x = 0
  @far.position.y = 0
  @stage.addChild @far

  midTexture = PIXI.Texture.fromImage '../img/bg-mid.png'
  @mid = new PIXI.Sprite midTexture
  @mid.position.x = 0
  @mid.position.y = 128
  @stage.addChild @mid

  requestAnimFrame update

update = ->
  @far.position.x -= 0.128
  @mid.position.x -= 0.64

  @renderer.render @stage
  requestAnimFrame update

$ ->
  init()
