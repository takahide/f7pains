G =
  selectedPlayer: 0

$ ->
  $("#menu .menu .detail").on "click", ->
    i = $(@).index("#menu .menu .detail") + 1
    $("#player .image").attr "src", "img/players/player#{i}.jpg"
