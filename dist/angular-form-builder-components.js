(function() {
  angular.module('builder.components', ['builder', 'validator.rules']).config([
    '$builderProvider', function($builderProvider) {
      $builderProvider.registerComponent('message', {
        group: 'Basic',
        placeholder: 'Rich Content',
        label: 'Rich Content',
        template: "<div class=\"row\" id=\"{{formName+index | nospace}}\">\n    <label class=\"col-sm-2 control-label\" for=\"{{formName+index}}\"><i ng-if =\"formObject.logic.component\" id=\"hasLogic\" class=\"fa fa-random label-logic\"></i>\n    </label>\n     <div class=\"col-sm-10 form-group text-left\">\n      <rich-text><strong>Text Message</strong></rich-text>\n    </div>\n</div>\n<div id=\"dashedline\" class=\"hr-line-dashed\"></div>",
        popoverTemplate: "<div></div>"
      });
      $builderProvider.registerComponent('email', {
        group: 'Basic',
        label: 'Email Input',
        description: '',
        requireConfirmation: false,
        required: false,
        readOnly: false,
        template: "<div class=\"row\" id=\"{{formName+index | nospace}}\">\n      <label class=\"col-sm-2 control-label\" for=\"{{formName+index}}\" ng-class=\"{'fb-required':required}\"><i ng-if =\"formObject.logic.component\" id=\"hasLogic\" class=\"fa fa-random label-logic\"></i> {{label}}\n      </label>\n        <div class=\"col-sm-10\">\n            <div class=\"input-group m-b\">\n             <span class=\"input-group-addon\">@</span>\n             <input ng-readonly=\"readOnly\" type=\"email\" ng-model=\"inputText.email\" placeholder=\"{{placeholder}}\" class=\"form-control custom-m-b\" validator-required=\"{{required}}\" validator-group=\"{{formName}}\">\n           </div>\n           <div class=\"input-group m-b\">\n             <span ng-show=\"requireConfirmation\" class=\"input-group-addon\">@</span>\n             <input ng-readonly=\"readOnly\" type=\"email\" ng-show=\"requireConfirmation\" ng-model=\"inputText.confirmation\" placeholder=\"Confirm email\" class=\"form-control m-b\" id=\"confirmEmail\">\n           </div>\n        </div>\n    <div class=\"col-sm-10 col-sm-offset-2\">\n      <small ng-show=\"description\" class='help-block text-muted custom-small'>{{description}}</small>\n    </div>\n</div>\n<div id=\"dashedline\" class=\"hr-line-dashed\"></div>",
        popoverTemplate: "<div></div>"
      });
      $builderProvider.registerComponent('date', {
        group: 'Basic',
        label: 'Date Picker',
        description: '',
        required: false,
        disableWeekends: false,
        readOnly: false,
        template: "<div class=\"row\" id=\"{{formName+index | nospace}}\">\n      <label class=\"col-sm-2 control-label\" for=\"{{formName+index}}\" ng-class=\"{'fb-required':required}\"><i ng-if =\"formObject.logic.component\" id=\"hasLogic\" class=\"fa fa-random label-logic\"></i> {{label}}</label>\n      <div class=\"col-sm-10\">\n        <ui-date weekends=\"{{disableWeekends}}\"></ui-date>\n      </div>\n    <div class=\"col-sm-10 col-sm-offset-2\">\n      <small ng-show=\"description\" class=\"help-block text-muted custom-small\">{{description}}</small>\n    </div>\n</div>\n<div id=\"dashedline\" class=\"hr-line-dashed\"></div>",
        popoverTemplate: "<div></div>"
      });
      $builderProvider.registerComponent('text', {
        group: 'Basic',
        label: 'Text Input',
        description: '',
        placeholder: 'placeholder',
        readOnly: false,
        minLength: 0,
        maxLength: 999,
        minRange: 0,
        maxRange: 99999,
        required: false,
        validationOptions: [
          {
            label: 'None',
            rule: '/.*/'
          }, {
            label: 'Text',
            rule: '[text]'
          }, {
            label: 'Number',
            rule: '[numberRange]'
          }
        ],
        template: "<div class=\"row\" id=\"{{formName+index | nospace}}\">\n    <label class=\"col-sm-2 control-label\" for=\"{{formName+index}}\" ng-class=\"{'fb-required':required}\"><i ng-if =\"formObject.logic.component\" id=\"hasLogic\" class=\"fa fa-random label-logic\"></i> {{label}}</label>\n    <div class=\"col-sm-10\">\n        <input type=\"text\" ng-show=\"validation != '[numberRange]'\" ng-readonly=\"readOnly\" ng-model=\"inputText\" validator-required=\"{{required}}\" validator-group=\"{{formName}}\" class=\"form-control m-b\" placeholder=\"{{placeholder}}\"/>\n        <input type=\"tel\" ng-show=\"validation === '[numberRange]'\" ng-readonly=\"readOnly\" ng-model=\"inputText\" validator-required=\"{{required}}\" validator-group=\"{{formName}}\" class=\"form-control m-b\" placeholder=\"{{placeholder}}\"/>\n    </div>\n  <div class=\"col-sm-10 col-sm-offset-2\">\n    <small ng-show=\"description\" class=\"help-block text-muted custom-small\">{{description}}</small>\n  </div>\n</div>\n<div id=\"dashedline\" class=\"hr-line-dashed\"></div>",
        popoverTemplate: "<div></div>"
      });
      $builderProvider.registerComponent('area', {
        group: 'Basic',
        label: 'Text Area',
        description: '',
        placeholder: 'placeholder',
        required: false,
        readOnly: false,
        template: "<div class=\"row\" id=\"{{formName+index | nospace}}\">\n    <label class=\"col-sm-2 control-label\" for=\"{{formName+index}}\" ng-class=\"{'fb-required':required}\"><i ng-if =\"formObject.logic.component\" id=\"hasLogic\" class=\"fa fa-random label-logic\"></i> {{label}}</label>\n    <div class=\"col-sm-10\">\n        <textarea type=\"text\" ng-readonly=\"readOnly\" ng-model=\"inputText\" validator-required=\"{{required}}\" validator-group=\"{{formName}}\" class=\"form-control m-b\" rows='6' placeholder=\"{{placeholder}}\"/>\n    </div>\n    <div class=\"col-sm-10 col-sm-offset-2\">\n      <small ng-show=\"description\" class=\"help-block text-muted custom-small\">{{description}}</small>\n    </div>\n</div>\n<div id=\"dashedline\" class=\"hr-line-dashed\"></div>",
        popoverTemplate: "<div></div>"
      });
      $builderProvider.registerComponent('checkbox', {
        group: 'Choice',
        label: 'Checkbox',
        description: '',
        placeholder: 'placeholder',
        required: false,
        options: ['value one', 'value two'],
        arrayToText: true,
        readOnly: false,
        template: "<div class=\"row\" id=\"{{formName+index | nospace}}\">\n    <label for=\"{{formName+index}}\" class=\"col-sm-2 control-label\" ng-class=\"{'fb-required':required}\"><i ng-if =\"formObject.logic.component\" id=\"hasLogic\" class=\"fa fa-random label-logic\"></i> {{label}}</label>\n    <div class=\"col-sm-10\">\n        <input type='hidden' ng-model=\"inputText\" validator-required=\"{{required}}\" validator-group=\"{{formName}}\"/>\n        <div class='checkbox icheck-label' ng-repeat=\"item in options track by $index\">\n          <input id=\"{{formName+index+'_'+$index | nospace}}\" ng-model=\"inputArray[$index]\" ng-value='item' ng-disabled=\"readOnly\" type=\"checkbox\" checked=\"\">\n          <label for=\"{{formName+index+'_'+$index | nospace}}\">{{item}}</label>\n        </div>\n    </div>\n    <div class=\"col-sm-10 col-sm-offset-2\">\n      <small ng-show=\"description\" class=\"help-block text-muted custom-small\">{{description}}</small>\n    </div>\n</div>\n<div id=\"dashedline\" class=\"hr-line-dashed\"></div>",
        popoverTemplate: "<div></div>"
      });
      $builderProvider.registerComponent('radio', {
        group: 'Choice',
        label: 'Radio',
        description: '',
        placeholder: 'placeholder',
        required: false,
        readOnly: false,
        options: ['value one', 'value two'],
        template: "<div class=\"row\" id=\"{{formName+index | nospace}}\">\n    <label for=\"{{formName+index}}\" class=\"col-sm-2 control-label\" ng-class=\"{'fb-required':required}\"><i ng-if =\"formObject.logic.component\" id=\"hasLogic\" class=\"fa fa-random label-logic\"></i> {{label}}</label>\n    <div class=\"col-sm-10\">\n        <div class='radio icheck-label' ng-repeat=\"item in options track by $index\">\n\n            <input id=\"{{formName+index+'_'+$index | nospace}}\" type=\"radio\" ng-disabled=\"readOnly\" name='{{formName+index}}' ng-model=\"$parent.inputText\" validator-group=\"{{formName}}\" ng-value='item'>\n            <label for=\"{{formName+index+'_'+$index | nospace}}\">{{item}}</label>\n\n        </div>\n    </div>\n    <div class=\"col-sm-10 col-sm-offset-2\">\n      <small ng-show=\"description\" class=\"help-block text-muted custom-small\">{{description}}</small>\n    </div>\n</div>\n<div id=\"dashedline\" class=\"hr-line-dashed\"></div>",
        popoverTemplate: "<div></div>"
      });
      return $builderProvider.registerComponent('select', {
        group: 'Choice',
        label: 'Select',
        description: '',
        placeholder: 'Choose..',
        required: false,
        readOnly: false,
        options: ['value one', 'value two'],
        template: "<div class=\"row\" id=\"{{formName+index | nospace}}\">\n    <label class=\"col-sm-2 control-label\" for=\"{{formName+index}}\" ng-class=\"{'fb-required':required}\"><i ng-if =\"formObject.logic.component\" id=\"hasLogic\" class=\"fa fa-random label-logic\"></i> {{label}}</label>\n    <div class=\"col-sm-10 dropdown\">\n        <select ng-show=\"!multiple\" ng-readonly=\"readOnly\" ng-options=\"value for value in options\" class=\"form-control m-b\"\n            ng-model=\"inputText\" ng-init=\"inputText = ''\">\n            <option value=\"\">{{placeholder}}</option>\n        </select>\n    </div>\n    <div class=\"col-sm-10 col-sm-offset-2\">\n      <small ng-show=\"description\" class=\"help-block text-muted custom-small\">{{description}}</small>\n    </div>\n</div>\n<div id=\"dashedline\" class=\"hr-line-dashed\"></div>",
        popoverTemplate: "<div></div>"
      }, $builderProvider.registerComponent('address', {
        group: 'Advanced',
        label: 'Address Field',
        description: '',
        required: false,
        readOnly: false,
        placeholder: {
          StreetName: 'Street Name',
          Number: 'Number',
          Letter: 'Letter',
          Floor: 'Floor',
          PlaceName: 'Place Name',
          PostCode: 'Post Code',
          City: 'City'
        },
        options: [],
        template: "<div class=\"row\" id=\"{{formName+index | nospace}}\">\n    <label class=\"col-sm-2 control-label\" for=\"{{formName+index}}\" ng-class=\"{'fb-required':required}\"><i ng-if =\"formObject.logic.component\" id=\"hasLogic\" class=\"fa fa-random label-logic\"></i> {{label}}</label>\n    <div class=\"col-sm-10\">\n        <input type=\"text\" ng-readonly=\"readOnly\" ng-model=\"inputText.StreetName\" class=\"form-control custom-m-b\" placeholder=\"{{placeholder.StreetName}}\"/>\n        <input type=\"tel\" ng-readonly=\"readOnly\" ng-model=\"inputText.Number\" class=\"form-control custom-m-b\" placeholder=\"{{placeholder.Number}}\"/>\n        <input type=\"text\" ng-readonly=\"readOnly\" ng-model=\"inputText.Letter\" class=\"form-control custom-m-b\" placeholder=\"{{placeholder.Letter}}\"/>\n        <input type=\"text\" ng-readonly=\"readOnly\" ng-model=\"inputText.Floor\" class=\"form-control custom-m-b\" placeholder=\"{{placeholder.Floor}}\"/>\n        <input type=\"text\" ng-readonly=\"readOnly\" ng-model=\"inputText.PlaceName\" class=\"form-control custom-m-b\" placeholder=\"{{placeholder.PlaceName}}\"/>\n        <input type=\"text\" ng-readonly=\"readOnly\" ng-model=\"inputText.PostCode\" class=\"form-control custom-m-b\" placeholder=\"{{placeholder.PostCode}}\"/>\n        <input type=\"text\" ng-readonly=\"readOnly\" ng-model=\"inputText.City\" class=\"form-control m-b\" placeholder=\"{{placeholder.City}}\" validator-required={{required}} validator-group={{formName}}/>\n    </div>\n    <div class=\"col-sm-10 col-sm-offset-2\">\n        <small ng-show=\"description\" class=\"help-block text-muted custom-small\">{{description}}</small>\n    </div>\n</div>\n<div id=\"dashedline\" class=\"hr-line-dashed\"></div>",
        popoverTemplate: "<div></div>"
      }, $builderProvider.registerComponent('signature', {
        group: 'Advanced',
        label: 'Signature Pad',
        decription: 'description',
        required: false,
        readOnly: false,
        template: "<div class=\"row\" id=\"{{formName+index | nospace}}\">\n    <label class=\"col-sm-2 control-label\" for=\"{{formName+index}}\" ng-class=\"{'fb-required':required}\"><i ng-if =\"formObject.logic.component\" id=\"hasLogic\" class=\"fa fa-random label-logic\"></i> {{label}}</label>\n\n    <div class=\"col-sm-10\">\n        <div class=\"m-b\">\n            <signature-pad></signature-pad>\n        </div>\n    </div>\n    <div class=\"col-sm-10 col-sm-offset-2\">\n        <small ng-show=\"description\" class=\"help-block text-muted custom-small\">{{description}}</small>\n    </div>\n</div>\n<div id=\"dashedline\" class=\"hr-line-dashed\"></div>",
        popoverTemplate: "<div></div>"
      })));
    }
  ]);

}).call(this);
