//= require header
//= require_tree ./controllers
//= require_tree ./services
//= require_tree ./directives
//= require filters
//= require_self

var shepherdModule = angular.module('shepherd',['ngRoute','ngAnimate','ui.router','angularMoment'
  // 'services', 'directives','filters'
  ]);

shepherdModule
.config(['$stateProvider','$urlRouterProvider', '$locationProvider',
  function($stateProvider, $urlRouterProvider, $locationProvider) {
    /**
     * Routes and States
     */
     $stateProvider
     .state('home', {
      url: '/',
      templateUrl: 'home.html',
      controller: 'HomeCtrl'
    });

    // default fall back route
    $urlRouterProvider.otherwise('/');

  }])
.config(["$httpProvider", function(provider) {
  provider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content'),
  provider.defaults.headers.common['Content-Type'] = 'application/json';
}])
.config(['RestangularProvider', function(provider) {
  provider.setRestangularFields({ id: "_id" });
}]);

shepherdModule.run(['$rootScope', '$window', function($rootScope, $window) {

  // basic media query for angularjs
  $rootScope.mobile = function() {
    return ($window.innerWidth < 767) ? true : false;
  };

}]);
