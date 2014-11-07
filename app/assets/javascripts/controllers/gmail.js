angular.module('shepherd.gmail', ['ngSanitize'])
.controller('GmailCtrl',['$scope','$stateParams','Restangular', function ($scope, $stateParams, Restangular) {
	var id = $stateParams.id;

  $scope.email_update = true;
  Restangular.one('gmail/inbox').get({q: id}).then( function(inbox) {
    $scope.messages = inbox.messages;
    $scope.nextPageToken = inbox.nextPageToken;
    $scope.email_update = false;
  }, function () { $scope.email_update = false; });

  $scope.more = function (nextPageToken) {
    $scope.email_update = true;
    Restangular.one('gmail/inbox').get({q: id, pageToken: nextPageToken}).then( function(inbox) {
      $scope.messages = $scope.messages.concat(inbox.messages);
      $scope.nextPageToken = inbox.nextPageToken;
      $scope.email_update = false;
    }, function () { $scope.email_update = false; });
  }

  $scope.hasLabel = function (item, label) {
    return item.labelIds.indexOf(label) > -1;
  };

}]);