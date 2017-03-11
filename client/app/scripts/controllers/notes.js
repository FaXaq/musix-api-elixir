'use strict';

/**
 * @ngdoc function
 * @name musix.controller:NotesCtrl
 * @description
 * # NotesCtrl
 * Controller of the
 */
angular.module('musix')
       .controller('NotesCtrl', function ($scope, $http) {
           var notes = {};
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
       });
