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
.controller('NotesCtrl', ['$scope','$stateParams', 'Restangular', '$rootScope', 'logger',
  function($scope, $stateParams, Restangular, $rootScope, logger) {
    var uid = $stateParams.id;

    Restangular.one('users',uid).get()
    .then( function(user) {
      $scope.user = user;
    });

    var refresh = function (broadcast) {
      Restangular.all('leads/' + uid + '/notes' ).getList().then( function(notes) {
        $scope.notes = notes;
        $scope.remainingCount = _.filter(notes, function (note) { return !!note.due_date && !note.completed; }).length;
        console.info("refresh notes", broadcast)
        if (!!broadcast) $rootScope.$broadcast('taskRemaining:changed');
      });
    };
    refresh();

    $scope.add = function() {
      if (!$scope.note) return;
      $scope.note.uid = uid;
      $scope.note.name = (!!$scope.user && !!$scope.user.name) ? $scope.user.name : $scope.lead.info.name;
      $scope.note.company = (!!$scope.user && !!$scope.user.company) ? $scope.user.company.name : $scope.lead.info.company;
      $scope.note.site = $rootScope.site;

      Restangular.all('notes').post($scope.note).then( function (note) {
        var msg = (!!note.due_date) ? 'New Reminder added' : 'New Note added';
        logger.logSuccess(msg);
        $scope.note = {};
        refresh(true);
      });
    };

    $scope.edit = function(note) {
      return $scope.editedNote = note;
    };

    $scope.doneEditing = function(note) {
      $scope.editedTask = null;
      Restangular.one('notes').post(note._id, note).then( function (note) {
        logger.logSuccess('Note Updated!');
        refresh();
      });
    };

    $scope.remove = function(note) {
      Restangular.one('notes',note._id).remove().then( function (resp) {
        refresh(true);
      });
      return logger.logError('Note has been removed!');
    };

    $scope.completed = function(note) {
      console.info("completed", note)
      Restangular.one('notes').post(note._id, note).then( function (note) {
        logger.logSuccess('Reminder Completed!');
        refresh(true);
      });
    };
  }]);