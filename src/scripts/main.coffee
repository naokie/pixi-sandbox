init = ->
  stage = new PIXI.Stage 0x66FF99
  renderer = PIXI.autoDetectRenderer 512, 384
  document.body.appendChild renderer.view
  renderer.render stage

$ ->
  init()
