angular.module('shepherd.gmail', ['ngSanitize'])
.controller('GmailCtrl',['$scope','$stateParams','Restangular','logger', function ($scope, $stateParams, Restangular, logger) {
	var id = $stateParams.id;

  $scope.inbox = function (nextPageToken) {
    $scope.email_update = true;
    var query = { q: id };
    if (!!$scope.query) query.q += ' ' + $scope.query;
    if (!!nextPageToken) { query.pageToken = nextPageToken };

    Restangular.one('gmail/inbox').get(query).then( function(inbox) {
      if (!!$scope.messages && !!nextPageToken) {      
        $scope.messages = $scope.messages.concat(inbox.messages);
      } else {
        $scope.messages = inbox.messages;
      }
      $scope.nextPageToken = inbox.nextPageToken;
      $scope.email_update = false;
    }, function () { $scope.email_update = false; });
  };
  $scope.inbox();

  $scope.$watch('query', function () { $scope.inbox(); });

  $scope.read = function (id) {
    $scope.email_update = true;
    Restangular.one('gmail/message', id).get().then( function(message) {
      $scope.message = message;
      $scope.email_update = false;
      $scope.show_message = true;
      $scope.message_link = 'https://mail.google.com/mail/u/0/#inbox/' + id;
    }, function () { $scope.email_update = false; });
  };

  $scope.compose = false;
  $scope.send = function () {
    $scope.sending = true;
    Restangular.one('gmail/message').post(id, $scope.new_message).then( function(status) {
      console.info("Sent!", status);
      logger.logSuccess("Message Sent!");
      $scope.closeCompose();
    }, function () { $scope.sending = false; logger.logError("Bummer, something went wrong...") });
  };

  $scope.closeCompose = function () {
    $scope.new_message = false;
    $scope.compose = false;
  };

  $scope.closeMessage = function () { $scope.show_message = false; };

  $scope.hasLabel = function (item, label) {
    if (!angular.isObject(item)) return false;
    return item.labelIds.indexOf(label) > -1;
  };

}]);