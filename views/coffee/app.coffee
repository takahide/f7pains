G =
  selectedPost: 0

'use strict'
rokuro = angular.module 'myApp', ['onsen.directives']

rokuro.controller 'topController', ($scope) ->
  $('#top .post .img').on 'click', ->
    G.selectedPost = $("img", this).attr "src"
    $scope.ons.navigator.pushPage 'details.html', {title: "写真"}

  $('#top .post .buttons .button').on 'click', ->
    $(".icon", this).css "color", "rgb(200, 103, 100)"

rokuro.controller 'detailsController', ($scope) ->
  $('#details .photo').attr "src", G.selectedPost

