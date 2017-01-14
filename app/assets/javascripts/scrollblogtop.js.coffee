ready = ->
  $(window).scroll ->
    element = $('#page-blogtop-btn')
    visible = element.is(':visible')
    height = $(window).scrollTop()
    if height > 200
      element.fadeIn() if !visible
    else
      element.fadeOut()

$(document).ready(ready)
$(document).on('page:load', ready)
