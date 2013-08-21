# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

window.callAjaxRequest = (email, ssUrl) ->
  $.ajax {
    type: "GET"
    dataType: 'html'
    data: {email: email}
    url: ssUrl 
    success: (result) ->
      # console.log(res)
  }
  false

add_remove_active_class = (div_param, remove=true) ->
  if remove
    $(div_param).removeClass('active')
  else
    $(div_param).addClass('active')  

  
show_hide_header_link = (div_param, hide=true) ->
  if hide    
    $(div_param).hide()
  else
    $(div_param).show()
    
$(document).ready ->
  
  $("input:text").eq(0).focus()
  
  $('#notice').delay(2000).animate
    height: '0px'
    opacity: 0
    
  $('#error').delay(2000).animate
    height: '0px'
    opacity: 0
    
  $('#search_button_id1').click (e) ->
    $("#spinner").show()