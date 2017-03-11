'use strict';

/**
 * @ngdoc function
 * @name clientApp.controller:MainCtrl
 * @description
 * # MainCtrl
 * Controller of the clientApp
 */
angular.module('musix')
       .controller('MainCtrl', function ($scope, $route) {
           this.awesomeThings = [
               'HTML5 Boilerplate',
               'AngularJS',
               'Karma'
           ];

           $scope.$route = $route;
       });
