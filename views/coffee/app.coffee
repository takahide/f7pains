class Page
  _player = 0
  setPlayer: (id) ->
    $("#profile#{_player}").addClass "hidden"
    _player = parseInt id
    $("#profile#{_player}").removeClass "hidden"
  getPlayer: ->
    return _player

page = new Page()

$(".player").on "click", ->
  page.setPlayer $(@).attr("player")

$(".submit").on "click", ->
  game = $("body").attr("game")
  player = page.getPlayer()
  $.ajax {
    type: "POST"
    url: "register"
    data: {
      score0: '{"game": ' + game + ', "player": ' + player + ', "result": "' + $("#" + player + "-score0").val() + '"}'
      score1: '{"game": ' + game + ', "player": ' + player + ', "result": "' + $("#" + player + "-score1").val() + '"}'
      score2: '{"game": ' + game + ', "player": ' + player + ', "result": "' + $("#" + player + "-score2").val() + '"}'
      score3: '{"game": ' + game + ', "player": ' + player + ', "result": "' + $("#" + player + "-score3").val() + '"}'
      score4: '{"game": ' + game + ', "player": ' + player + ', "result": "' + $("#" + player + "-score4").val() + '"}'
      score5: '{"game": ' + game + ', "player": ' + player + ', "result": "' + $("#" + player + "-score5").val() + '"}'
      score6: '{"game": ' + game + ', "player": ' + player + ', "result": "' + $("#" + player + "-score6").val() + '"}'
      score7: '{"game": ' + game + ', "player": ' + player + ', "result": "' + $("#" + player + "-score7").val() + '"}'
      score8: '{"game": ' + game + ', "player": ' + player + ', "result": "' + $("#" + player + "-score8").val() + '"}'
      score9: '{"game": ' + game + ', "player": ' + player + ', "result": "' + $("#" + player + "-score9").val() + '"}'
    }
    success: ->
      alert "成功"
    error: ->
      alert "失敗"
  }

flipsnap = Flipsnap '.flipsnap', {
  distance: 300
}
$next = $('.next').click ->
  flipsnap.toNext()

$prev = $('.prev').click ->
  flipsnap.toPrev()

flipsnap.element.addEventListener 'fspointmove', ->
  $next.attr 'disabled', !flipsnap.hasNext()
  $prev.attr 'disabled', !flipsnap.hasPrev()
, false
