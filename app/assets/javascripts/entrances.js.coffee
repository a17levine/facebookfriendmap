# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

showUserText = (notificationString) ->
  $("#status-text").text notificationString
  setTimeout (->
    $("#status-text").text("")
    return
  ), 4000
  return

$(document).on "ajax:success", ".entrance-form", ->
  console.log "Friends successfully added to the map. Logging out..."
  FB.logout()
  showUserText "friends added! you are now logged out of facebook"
  console.log "Logged out."
  $("#loginbutton").removeAttr "disabled"
  return

window.launchEntrancesJS = ->
  $(document).ready -> 
  	new Formatter(document.getElementById("phone-input"),
    pattern: "({{999}}) {{999}}.{{9999}}"
    persistent: true
  	)

  	window.fbAsyncInit = ->
    
    # init the FB JS SDK
    FB.init
      appId: "680908225263965" # App ID from the app dashboard
      status: true # Check Facebook Login status
      xfbml: true # Look for social plugins on the page



  	# Additional initialization code such as adding Event Listeners goes here

  	# Load the SDK asynchronously
  	((d, s, id) ->
  	  js = undefined
  	  fjs = d.getElementsByTagName(s)[0]
  	  return  if d.getElementById(id)
  	  js = d.createElement(s)
  	  js.id = id
  	  js.src = "http://connect.facebook.net/en_US/all.js"
  	  fjs.parentNode.insertBefore js, fjs
  	) document, "script", "facebook-jssdk"

  	$("#loginbutton").click ->
    $("#loginbutton").attr "disabled", "disabled"
    FB.login (response) ->
      if response.authResponse
        $("#status-text").text("processing friends")
        console.log "the access token is " + FB.getAccessToken()
        FB.api "/me", (response) ->
          console.log response
          console.log "Good to see you, " + response.name + "."
          phone = $("#phone-input").val()
          console.log "Phone number is "+ phone
          $("#entrance_facebook_token").val(FB.getAccessToken())
          #console.log "Logging you out"
          #FB.logout()
          console.log "Posting access token and phone number to the server"
          $("#hidden_submit").click()
      else
        console.log "User cancelled login or did not fully authorize."
        showUserText "user cancelled or did not authorize"



