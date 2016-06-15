$(document).ready () ->
  $('[title]').tooltip()


  clip = new ZeroClipboard $(".clip_button")
  clip.on "aftercopy", (event) ->
    event.target.className = 'clip_button btn btn-default glyphicon glyphicon-ok'
