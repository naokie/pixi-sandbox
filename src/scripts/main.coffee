init = ->
  @stage = new PIXI.Stage 0x66FF99
  @renderer = PIXI.autoDetectRenderer 512, 384
  document.body.appendChild @renderer.view

  farTexture = PIXI.Texture.fromImage '../img/bg-far.png'
  far = new PIXI.Sprite farTexture
  far.position.x = 0
  far.position.y = 0
  @stage.addChild far

  requestAnimFrame update

update = ->
  @renderer.render @stage
  requestAnimFrame update

$ ->
  init()
