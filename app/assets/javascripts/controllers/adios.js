function AdiosCtrl( Restangular) {
	console.info("Adios!");
	Restangular.one('signout').get();
}
AdiosCtrl.$inject = ['Restangular'];