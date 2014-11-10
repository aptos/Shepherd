angular.module('shepherd.gmail', ['ngSanitize'])
.controller('GmailCtrl',['$scope','$stateParams','Restangular', function ($scope, $stateParams, Restangular) {
	var id = $stateParams.id;

  $scope.email_update = true;
  Restangular.one('gmail/inbox').get({q: id}).then( function(inbox) {
    $scope.messages = inbox.messages;
    $scope.nextPageToken = inbox.nextPageToken;
    $scope.email_update = false;
  }, function () { $scope.email_update = false; $scope.error = true; });

  $scope.more = function (nextPageToken) {
    $scope.email_update = true;
    Restangular.one('gmail/inbox').get({q: id, pageToken: nextPageToken}).then( function(inbox) {
      $scope.messages = $scope.messages.concat(inbox.messages);
      $scope.nextPageToken = inbox.nextPageToken;
      $scope.email_update = false;
    }, function () { $scope.email_update = false; });
  };

  $scope.read = function (id) {
    $scope.email_update = true;
    Restangular.one('gmail/message', id).get().then( function(message) {
      $scope.message = message;
      $scope.email_update = false;
      $scope.show_message = true;
      $scope.message_link = 'https://mail.google.com/mail/u/0/#inbox/' + id;
    }, function () { $scope.email_update = false; });
  };

  $scope.closeMessage = function () { $scope.show_message = false; }

  $scope.hasLabel = function (item, label) {
    return item.labelIds.indexOf(label) > -1;
  };

}]);