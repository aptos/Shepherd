//= require_tree ./controllers
//= require_tree ./directives
//= require_self

var app = angular.module('shepherd', [
  'ngAnimate',
  'ui.router',
  'templates',
  'restangular',
  'ui.bootstrap',
  'shepherd.dashboard',
  'shepherd.maps'
])
.config(['$stateProvider', '$urlRouterProvider', '$locationProvider',
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
    });

    // default fallback route
    $urlRouterProvider.otherwise('/');

    // enable HTML5 mode for SEO
    $locationProvider.html5Mode(true);

  }])
.controller('HomeCtrl',[function () {
  console.info("Welcome Home!");
}])
.controller('AdiosCtrl',['Restangular', '$window', function ( Restangular, $window) {
  console.info("Adios!");
  Restangular.one('signout').get();
  $window.location.reload();
}]);