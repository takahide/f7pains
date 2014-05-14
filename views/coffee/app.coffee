'use strict'
baseball = angular.module 'myApp', ['onsen.directives']

baseball.controller 'topController', ($scope) ->
  $scope.goToPlayer = ->
    $scope.ons.navigator.pushPage 'player.html', '細川貴英'
