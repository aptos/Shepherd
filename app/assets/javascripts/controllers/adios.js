function AdiosCtrl( Restangular, $window) {
	console.info("Adios!");
	Restangular.one('signout').get();
  $window.location.reload();
}
AdiosCtrl.$inject = ['Restangular', '$window'];