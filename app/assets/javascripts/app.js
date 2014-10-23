//= require header
//= require_tree ./controllers
//= require_tree ./directives
//= require_self

var shepherdModule = angular.module('shepherd', [ 'ngAnimate', 'ui.router','templates','restangular','ui.bootstrap','Directives' ]);

shepherdModule.config(['$stateProvider', '$urlRouterProvider', '$locationProvider',
  function ($stateProvider, $urlRouterProvider, $locationProvider) {

    $stateProvider
    .state('home', {
      url: '/',
      templateUrl: 'home.html',
      controller: 'HomeCtrl'
    })
    .state('signout', {
      url: '/signout',
      templateUrl: 'signin.html',
      controller: 'AdiosCtrl'
    })
    .state('dashboard', {
      url: '/dashboard',
      views: {
        '': { templateUrl: 'dashboard/layout.html' },
        'worldMap@dashboard': {
          templateUrl: 'dashboard/user_map.html',
          controller: 'UsersCtrl'
        }
      }
    });

    // default fallback route
    $urlRouterProvider.otherwise('/');

    // enable HTML5 mode for SEO
    $locationProvider.html5Mode(true);

  }]);