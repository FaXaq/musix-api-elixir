'use strict';

/**
 * @ngdoc function
 * @name musix.controller:ChordsCtrl
 * @description
 * # ChordsCtrl
 * Controller of musix
 */
angular.module('musix')
       .controller('ChordsCtrl', function ($scope, $http, $routeParams, $route) {

           /**
           * @ngdoc function to gather all chords currently available with a root note
           */
           function getAllChords(chords, note) {
               for (var i in chords) {
                   getChord(chords, note, i);
               }
           }

           /**
           * @ngdoc function to gather a specific chord, with its code and root note
           */
           function getChord(chords, root, chord) {
               $http({
                   method: 'GET',
                   url: 'http://localhost:4000/api/v1/chords/' + chord + '/' + root
               }).then(function successCallback(response) {
                   chords[chord].chord = response.data.chord;
               }, function errorCallback() {
                   $scope.error = "couldn't load specific chord, error";
               });
           }

           var chords = {};
           $http({
               method: 'GET',
               url: 'http://localhost:4000/api/v1/chords'
           }).then(function successCallback(response) {
               var allChords = response.data.chords;
               for (var n in allChords) {
                   chords[n] = allChords[n];
               }

               if ($routeParams.note) {
                   $scope.root = $routeParams.note;
                   getAllChords(chords, $routeParams.note, $scope, $http);
               }

               $scope.chords = chords;
           }, function errorCallback() {
               $scope.error = "couldn't load the notes, error";
           });

           $scope.$route = $route;
       });
