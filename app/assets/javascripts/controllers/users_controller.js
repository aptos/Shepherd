function UsersCtrl($scope, Restangular) {
	console.info("Fetch Users");
	var marker_data;
	marker_data = [
	{
		"latLng": [40.71, -74.00],
		"name": "New York"
	}, {
		"latLng": [39.90, 116.40],
		"name": "Beijing"
	}, {
		"latLng": [31.23, 121.47],
		"name": "Shanghai"
	}, {
		"latLng": [-33.86, 151.20],
		"name": "Sydney"
	}, {
		"latLng": [-37.81, 144.96],
		"name": "Melboune"
	}, {
		"latLng": [37.33, -121.89],
		"name": "San Jose"
	}, {
		"latLng": [1.3, 103.8],
		"name": "Singapore"
	}
	];
	$scope.worldMap = {
		markers: marker_data
	};
}
UsersCtrl.$inject = ['$scope', 'Restangular'];