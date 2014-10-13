//= require header
//= require_tree ./controllers
//= require_tree ./services
//= require_tree ./directives
//= require filters
//= require_self

var shepherdModule = angular.module('shepherd',['ngRoute','ngAnimate','ui.router','angularMoment',
  // 'services', 'directives','filters'
  ]);

shepherdModule.config(['$stateProvider','$urlRouterProvider', '$locationProvider',function($stateProvider, $urlRouterProvider, $locationProvider) {
  }])
.config(["$httpProvider", function(provider) {
  provider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content'),
  provider.defaults.headers.common['Content-Type'] = 'application/json'
  }])
.config(['RestangularProvider', function(provider) {
  provider.setRestangularFields({ id: "_id" })
}]);

shepherdModule.run(['$rootScope', '$window', '$q', 'Restangular', 'Storage', function($rootScope, $window, $q, Restangular, Storage) {

  // basic media query for angularjs
  $rootScope.mobile = function() {
    return ($window.innerWidth < 767) ? true : false;
  };

}]);
