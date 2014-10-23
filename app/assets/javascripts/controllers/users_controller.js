function UsersCtrl($scope, Restangular) {

  $scope.as_of = "month";

  Restangular.all('api/users').getList()
  .then( function(users) {
    $scope.users = users;
    updateMap();
    $scope.total_users = $scope.users.length;
    $scope.new_users = users.reduce(function(u, user) { return (moment(user.created_at).isSame(moment(),$scope.as_of)) ? u + 1 : u; }, 0);
    $scope.visitors = users.reduce(function(u, user) { return (moment(user.updated_at).isSame(moment(),$scope.as_of)) ? u + 1 : u; }, 0);
  });


  // Initialize map
  var marker_data;
  // marker_data = [{ "latLng": [40.71, -74.00], "name": "New York" }];
  $scope.worldMap = {
    markers: marker_data
  };

  var updateMap = function () {
    var marker_data = [];
    _.each($scope.users, function (user) {
      if (!!user.latLong) {
        marker_data.push({
          "latLng": user.latLong,
          "name": user.name
        });
      }
    });
    $scope.markers = marker_data;
  };
}
UsersCtrl.$inject = ['$scope', 'Restangular'];