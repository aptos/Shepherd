function UsersCtrl($scope, Restangular) {

  Restangular.all('api/users').getList()
  .then( function(users) {
    $scope.users = users;
    updateMap();
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