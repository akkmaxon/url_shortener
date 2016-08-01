$(document).ready () ->
  $('[title]').tooltip()
  $('#console').hide()

  clip = new Clipboard ".clip_button"
  clip.on "success", (event) ->
    alert "#{event.text} copied to clipboard!"

  $('#console-toggle').click ()->
    $('#console').toggle()
