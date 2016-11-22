(function() {
  angular.module('builder.components', ['builder', 'validator.rules']).config([
    '$builderProvider', function($builderProvider) {
      return $builderProvider.registerComponent('message', {
        group: 'Basic',
        placeholder: 'Rich Content',
        label: 'Rich Content',
        template: "<div class=\"row\" id=\"{{formName+index | nospace}}\">\n    <label class=\"col-sm-2 control-label\" for=\"{{formName+index}}\"><i ng-if =\"formObject.logic.component\" id=\"hasLogic\" class=\"fa fa-random label-logic\"></i>\n    </label>\n     <div class=\"col-sm-10 form-group text-left\">\n      <rich-text><strong>Text Message</strong></rich-text>\n    </div>\n</div>\n<div id=\"dashedline\" class=\"hr-line-dashed\"></div>",
        popoverTemplate: "<div></div>"
      });
    }
  ]);

}).call(this);
