angular.module('shepherd.notes', [])
.directive('noteFocus', [
  '$timeout', function($timeout) {
    return {
      link: function(scope, ele, attrs) {
        return scope.$watch(attrs.noteFocus, function(newVal) {
          if (newVal) {
            return $timeout(function() {
              return ele[0].focus();
            }, 0, false);
          }
        });
      }
    };
  }])
.controller('NotesCtrl', ['$scope','$stateParams', 'Restangular', 'filterFilter', '$rootScope', 'logger', function($scope, $stateParams, Restangular, $rootScope, logger) {
  var uid = $stateParams.id;

  var refresh = function () {
    Restangular.all('api/leads/' + uid + '/notes' ).getList().then( function(notes) {
      $scope.notes = notes;
    });
  };
  refresh();

  $scope.add = function() {
    console.info("Add",$scope.note)
    $scope.note.uid = uid;
    Restangular.all('api/notes').post($scope.note).then( function (note) {
      logger.logSuccess('New note: "' + $scope.note.title + '" added');
      $scope.note = {};
      refresh();
    });
  };

  $scope.edit = function(note) {
    return $scope.editedNote = note;
  };

  $scope.doneEditing = function(note) {
    $scope.editedTask = null;
    Restangular.one('api/notes', note._id).post(note).then( function (note) {
      logger.logSuccess('Note Updated!');
      refresh();
    });
  };

  $scope.remove = function(note) {
    Restangular.one('api/notes', note.id).delete($scope.note).then( function (resp) {
      refresh();
    });
    return logger.logError('Note removed!');
  };

  $scope.completed = function(note) {
    console.info("completed", note)
  };

  // return $scope.$watch('remainingCount', function(newVal, oldVal) {
  //   return $rootScope.$broadcast('noteRemaining:changed', newVal);
  // });
}]);