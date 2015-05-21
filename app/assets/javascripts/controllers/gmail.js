angular.module('shepherd.gmail', ['ngSanitize'])
.controller('GmailCtrl',['$scope','$rootScope', '$stateParams','Restangular','logger', function ($scope,$rootScope, $stateParams, Restangular, logger) {
	var id = $stateParams.id;

  $scope.gmail = {
    new_message: {}
  };

  $scope.inbox = function (nextPageToken) {
    $scope.email_update = true;
    var query = { q: id };
    if (!!$scope.gmail.query) query.q += ' ' + $scope.gmail.query;
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

  $scope.$watch('gmail.query', function () { $scope.inbox(); });

  $scope.read = function (id) {
    $scope.email_update = true;
    Restangular.one('gmail/message', id).get().then( function(message) {
      $scope.message = message;
      if (!!message.headers['Content-Type'].match('text/plain')) {
        $scope.text_content = message.body;
      } else if (!!message.headers['Content-Type'].match('text/html')) {
        $scope.html_content = message.body;
      } else {
        $scope.text_content = "Sorry, don't know how to display " + message.headers['Content-Type'];
      }
      $scope.email_update = false;
      $scope.show_message = true;
      $scope.message_link = 'https://mail.google.com/mail/u/0/#inbox/' + id;

    }, function () { $scope.email_update = false; });
  };

  $scope.send = function (gmail) {
    $scope.sending = true;
    Restangular.one('gmail/message').post(id, gmail).then( function(status) {
      $scope.inbox();
      logger.logSuccess("Message Sent!");
      $scope.closeCompose();
      if (!!$scope.gmail.save_template) updateTemplates();
    }, function () { $scope.sending = false; logger.logError("Bummer, something went wrong...") });
  };

  $scope.template_names = [
  'CEO Welcome - A',
  'Concierge Welcome - A',
  'Followup - Educate',
  'Project Invitation'
  ];

  var updateTemplates = function () {
    console.info("Update Templates")
    Restangular.one('gmail/templates').get().then( function (templates) {
      $scope.templates = templates;
    }, function () { console.error('Oops!'); })
  };
  updateTemplates();

  $scope.compose = function () {
    console.info("Compose");
    $scope.composing = true;
    $scope.gmail.template = "";
    $scope.gmail.new_message = {};
  };

  $scope.chooseTemplate = function (name) {
    var template = _.find( $scope.templates, {name: name} );
    if (angular.isDefined(template)) {
      var first_name = (!!$scope.$parent.user) ? $scope.$parent.user.name.split(' ')[0] : $scope.$parent.lead.info.name.split(' ')[0];
      $scope.gmail.new_message = {
        subject: template.subject,
        body: 'Hi ' + first_name + ',\n\n' + template.body + '\n\nBest Regards,\n\n' + $rootScope.me.name
      };
      console.info("Template set", $scope.gmail );
    }
  };

  $scope.closeCompose = function () {
    $scope.gmail.new_message = false;
    $scope.composing = false;
  };

  $scope.closeMessage = function () { $scope.show_message = false; };

  $scope.hasLabel = function (item, label) {
    if (!angular.isObject(item)) return false;
    return item.labelIds.indexOf(label) > -1;
  };

}]);