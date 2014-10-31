angular.module('shepherd.widgets',[])
.directive('datepicker', function () {
  return {
    restrict:'A',
    require:'ngModel',
    link:function (scope, element, attrs, ngModel) {
      var minDateObject = new Date();
      if (attrs.minDate) {
        var day = moment(attrs.minDate, "YYYY-MM-DD");
        minDateObject = day.toDate();
      }
      element.datepicker({
        showOn:"both",
        changeYear:true,
        changeMonth:true,
        dateFormat:'yy-mm-dd',
        minDate:minDateObject,
        maxDate:new Date(2015, 11, 31),
        onSelect:function (dateText, inst) {
          ngModel.$setViewValue(dateText);
          scope.$apply();
        }
      });
      attrs.$observe('minDate', function (value) {
        if (!value) {
          return;
        }
        minDateObject = moment(value, "YYYY-MM-DD").toDate();
        element.datepicker("option", "minDate", minDateObject);
      });
    }
  };
})

.directive('selectAddtime', function () {
  return {
    restrict:'EA',
    require: 'ngModel',
    scope: {
      ngModel: '='
    },
    link:function (scope, element, attrs, ngModel) {
      scope.due_in = function (number, of, selected) {
        var dateObj = moment().add(number, of);
        ngModel.$setViewValue(dateObj.format('YYYY-MM-DD'));
        scope.when = dateObj.fromNow();
      };
    },
    /*jshint multistr: true */
    template: '<ul class="due-date nav nav-pills pull-right" role="tablist">\
    <li role="presentation" class="dropdown">\
    <a class="dropdown-toggle" data-toggle="dropdown" href="javascript:;">\
    <i class="fa fa-calendar"></i>\
    </a>\
    <div class="dropdown-menu with-arrow pull-right panel panel-default">\
    <div class="panel-heading">Remind me</div>\
    <ul class="list-group" role="menu">\
    <li class="list-group-item">\
    <a href="javascript:;" ng-click="due_in(1,\'d\',\'tomorrow\')">tomorrow</a>\
    </li>\
    <li class="list-group-item">\
    <a href="javascript:;" ng-click="due_in(1,\'w\',\'in a week\')">in a week</a>\
    </li>\
    <li class="list-group-item">\
    <a href="javascript:;" ng-click="due_in(2,\'w\',\'in 2 weeks\')">in 2 weeks</a>\
    </li>\
    <li class="list-group-item">\
    <a href="javascript:;" ng-click="due_in(1,\'M\',\'in a month\')">in a month</a>\
    </li>\
    </ul>\
    </div>\
    </li>\
    </ul><span class="due-date-label">{{when}}</span>'
  };
});