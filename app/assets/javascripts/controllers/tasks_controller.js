function TasksCtrl($scope, Restangular) {

  $scope.as_of = "month";

  Restangular.one('api/tasks/stats').get()
  .then( function(stats) {
    console.info("stats", stats)
    $scope.stats = stats;
  });

}
TasksCtrl.$inject = ['$scope', 'Restangular'];