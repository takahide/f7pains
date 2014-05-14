'use strict'
rokuro = angular.module 'myApp', ['onsen.directives']

rokuro.controller 'topController', ($scope) ->
  $('.post-img').on 'click', ->
    $scope.ons.navigator.pushPage 'details.html', {title: "hoge"}
