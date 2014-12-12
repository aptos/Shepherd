//= require_tree ./controllers
//= require_tree ./directives
//= require_tree ./services
//= require_self

var app = angular.module('shepherd', [
  'ngAnimate',
  'ngSanitize',
  'ngCookies',
  'ui.router',
  'templates',
  'restangular',
  'ui.bootstrap',
  'monospaced.elastic',
  'shepherd.services',
  'shepherd.widgets',
  'shepherd.header',
  'shepherd.dashboard',
  'shepherd.maps',
  'shepherd.users',
  'shepherd.profile',
  'shepherd.notes',
  'shepherd.activity',
  'shepherd.gmail',
  'shepherd.messages',
  'shepherd.campaigns'
  ])
.run(['$rootScope', '$state', '$stateParams', '$cookies',
  function ($rootScope, $state, $stateParams, $cookies) {
    $rootScope.$state = $state;
    $rootScope.$stateParams = $stateParams;

    $rootScope.is_due = function (due_date) {
      return moment(due_date).diff(moment(),'d') > 2;
    };
  }])
.config(["$httpProvider", function(provider) {
  provider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content');
}])
.config(['RestangularProvider', function(provider) {
  provider.setRestangularFields({ id: "_id" });
  provider.setBaseUrl('/api');
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