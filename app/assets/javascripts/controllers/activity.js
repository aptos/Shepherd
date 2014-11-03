angular.module('shepherd.activity', [])
.controller('ActivityCtrl',['$scope','$stateParams','Restangular', function ($scope, $stateParams, Restangular) {
	var id = $stateParams.id;
	$scope.icons = {
		'tasks': {fa:'fa-rocket', style:'btn-primary'},
		'bids': {fa:'fa-tag', style: 'btn-info'},
		'work_orders': {fa:'fa-tasks', style: 'btn-success'}
	};

	Restangular.all('api/users/' + id + '/activity' ).getList().then( function(activities) {
		$scope.activities = activities;
	});
}]);