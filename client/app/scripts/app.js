'use strict';

/**
 * @ngdoc overview
 * @name clientApp
 * @description
 * # clientApp
 *
 * Main module of the application.
 */
angular
    .module('musix', [
        'ngAnimate',
        'ngAria',
        'ngCookies',
        'ngMessages',
        'ngResource',
        'ngRoute',
        'ngSanitize',
        'ngTouch'
    ])
    .config(function ($routeProvider, $locationProvider) {

        /* get rid of #2F formating of `/` */
        $locationProvider.hashPrefix('');
        $routeProvider
            .when('/', {
                templateUrl: 'views/main.html',
                controller: 'MainCtrl',
                controllerAs: 'main',
                activeNav: 'home'
            })
            .when('/about', {
                templateUrl: 'views/about.html',
                controller: 'AboutCtrl',
                controllerAs: 'about',
                activeNav: 'about'
            })
            .when('/notes', {
                templateUrl: 'views/notes.html',
                controller: 'NotesCtrl',
                controllerAs: 'NotesCtrl',
                activeNav: 'notes'
            })
            .when('/chords', {
                templateUrl: 'views/chords.html',
                controller: 'ChordsCtrl',
                controllerAs: 'ChordsCtrl',
                activeNav: 'chords'
            })
            .when('/chords/:note', {
                templateUrl: 'views/chords.html',
                controller: 'ChordsCtrl',
                controllerAs: 'ChordsCtrl',
                activeNav: 'chords'
            })
            .otherwise({
                redirectTo: '/'
            });
    });
