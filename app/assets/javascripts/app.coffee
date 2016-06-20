$(document).ready () ->
  $('[title]').tooltip()


  clip = new Clipboard ".clip_button"
  clip.on "success", (event) ->
    alert "#{event.text} copied to clipboard!"
