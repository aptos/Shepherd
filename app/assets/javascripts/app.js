//= require_tree ./controllers
//= require_tree ./directives
//= require_tree ./services
//= require_self

var app = angular.module('shepherd', [
  'ngAnimate',
  'ngCookies',
  'ui.router',
  'templates',
  'restangular',
  'ui.bootstrap',
  'shepherd.services',
  'shepherd.dashboard',
  'shepherd.maps',
  'shepherd.users',
  'shepherd.profile',
  'shepherd.task'
  ])
.run(['$rootScope', '$state', '$stateParams', '$cookies',
  function ($rootScope, $state, $stateParams, $cookies) {
    $rootScope.$state = $state;
    $rootScope.$stateParams = $stateParams;
    $rootScope.site = $cookies.site || 'taskit';
  }])
.config(["$httpProvider", function(provider) {
  provider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')
}])
.config(['RestangularProvider', function(provider) {
  provider.setRestangularFields({ id: "_id" })
}])
.config(['$stateProvider', '$urlRouterProvider', '$locationProvider',
  function ($stateProvider, $urlRouterProvider, $locationProvider) {
    $stateProvider
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
.controller('AdiosCtrl',['Restangular', '$window', function ( Restangular, $window) {
  console.info("Adios!");
  Restangular.one('signout').get();
  $window.location.reload();
}])
.controller('SiteCtrl',['$scope', '$cookies', 'Restangular', '$window','$state', function ($scope, $cookies, Restangular, $window, $state) {
  $scope.site = $cookies.site || 'taskit';
  $scope.siteNames = {
    'taskit-pro': 'Juniper',
    'taskit': 'TaskIT'
  };
  $scope.setSite = function (site) {
    Restangular.one('api/site').get({site: site}).then( function (resp) {
      $scope.site = resp.site;
    }, function () { console.error(resp); });
    $state.go('dashboard');
    $window.location.reload();
  };
}])
.filter('moment', function() {
  return function(dateString, format, eob) {
    if (!dateString) { return "-"; }
    if (format) {
      if (format == "timeago") {
        if (eob == 'true') {
          return moment(dateString).add('days',1).fromNow();
        } else {
          return moment(dateString).fromNow();
        }
      } else {
        return moment(dateString).format(format);
      }
    } else {
      return moment(dateString).format("YYYY-MM-DD");
    }
  };
});