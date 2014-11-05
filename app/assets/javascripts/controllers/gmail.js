angular.module('shepherd.gmail', [])
.controller('GmailCtrl',['$scope','$stateParams','$http', function ($scope, $stateParams, $http) {
	var id = $stateParams.id;

	console.info("gmail loaded!")

	// GapiRestangular.all('users/' + id + '/messages' ).getList({},{Authorization: "Bearer " + token}).then( function(messages) {
	// 	$scope.messages = messages;
	// });

}]);