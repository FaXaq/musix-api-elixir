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
               $http({
                   method: 'GET',
                   url: 'http://localhost:4000/api/v1/chords/' + root
               }).then(function successCallback(response) {
                   chords = response.data.chords
                   $scope.chords = chords;
               }, function errorCallback() {
                   $scope.error = "couldn't load specific chord, error";
               });
           }

           /**
           * @ngdoc function to gather a specific chord, with its code and root note
           */
           function getChord(chords, root, chord) {
               $http({
                   method: 'GET',
                   url: 'http://localhost:4000/api/v1/chords/' + root + '/' + chord
               }).then(function successCallback(response) {
                   chords = response.data.chord;
                   $scope.chords = chords;
               }, function errorCallback() {
                   $scope.error = "couldn't load specific chord, error";
               });
           }

           var chords = {},
               root = $routeParams.note,
               chord = $routeParams.chord,
               notes = {};

           if (root && chord) {
               $scope.root = root;
               $scope.chord = chord;
               chords = {};
               getChord(chords, $routeParams.note, $routeParams.chord);
           } else {
               $http({
                   method: 'GET',
                   url: 'http://localhost:4000/api/v1/chords'
               }).then(function successCallback(response) {
                   chords = response.data.desc;

                   if (root) {
                       getAllChords(chords, $routeParams.note);
                   }

                   $scope.chords = chords;

               }, function errorCallback() {
                   $scope.error = "couldn't load the notes, error";
               });
           }

           $http({
               method: 'GET',
               url: 'http://localhost:4000/api/v1/notes'
           }).then(function successCallback(response) {
               var all_notes = response.data.notes;
               for (var n in all_notes) {
                   notes[all_notes[n]] = all_notes[n].replace("s","#");
               }
           }, function errorCallback() {
               $scope.error = "couldn't load the notes, error";
           });

           $scope.notes = notes;

           if (root) {
               $scope.root = root.replace("s","#");
           }

           $scope.notes = notes
           $scope.chords = chords;
       });
