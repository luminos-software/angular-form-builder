angular.module 'builder.components', ['builder', 'validator.rules']

.config ['$builderProvider', ($builderProvider) ->

    # ----------------------------------------
    # static text field
    # ----------------------------------------
    $builderProvider.registerComponent 'message',
        group: 'Basic'
        placeholder: 'Rich Content'
        label: 'Rich Content'
        template:
            """
            <div class="row" id="{{formName+index | nospace}}">
                <label class="col-sm-2 control-label" for="{{formName+index}}"><i ng-if ="formObject.logic.component" id="hasLogic" class="fa fa-random label-logic"></i>
                </label>
                 <div class="col-sm-10 form-group text-left">
                  <rich-text><strong>Text Message</strong></rich-text>
                </div>
            </div>
            <div id="dashedline" class="hr-line-dashed"></div>
            """
        popoverTemplate: "<div></div>"


    # ----------------------------------------
    # email field
    # ----------------------------------------
    $builderProvider.registerComponent 'email',
        group: 'Basic'
        label: 'Email Input'
        description: ''
        requireConfirmation: no
        required: no
        readOnly: no
        template:
            """
            <div class="row" id="{{formName+index | nospace}}">
                  <label class="col-sm-2 control-label" for="{{formName+index}}" ng-class="{'fb-required':required}"><i ng-if ="formObject.logic.component" id="hasLogic" class="fa fa-random label-logic"></i> {{label}}
                  </label>
                    <div class="col-sm-10">
                        <div class="input-group m-b">
                         <span class="input-group-addon">@</span>
                         <input ng-readonly="readOnly" type="email" ng-model="inputText.email" placeholder="{{placeholder}}" class="form-control custom-m-b" validator-required="{{required}}" validator-group="{{formName}}">
                       </div>
                       <div class="input-group m-b">
                         <span ng-show="requireConfirmation" class="input-group-addon">@</span>
                         <input ng-readonly="readOnly" type="email" ng-show="requireConfirmation" ng-model="inputText.confirmation" placeholder="Confirm email" class="form-control m-b" id="confirmEmail">
                       </div>
                    </div>
                <div class="col-sm-10 col-sm-offset-2">
                  <small ng-show="description" class='help-block text-muted custom-small'>{{description}}</small>
                </div>
            </div>
            <div id="dashedline" class="hr-line-dashed"></div>
            """
        popoverTemplate: "<div></div>"

    # ----------------------------------------
    # date picker
    # ----------------------------------------
    $builderProvider.registerComponent 'date',
        group: 'Basic'
        label: 'Date Picker'
        description: ''
        required: no
        disableWeekends: no
        readOnly: no
        template:
            """
            <div class="row" id="{{formName+index | nospace}}">
                  <label class="col-sm-2 control-label" for="{{formName+index}}" ng-class="{'fb-required':required}"><i ng-if ="formObject.logic.component" id="hasLogic" class="fa fa-random label-logic"></i> {{label}}</label>
                  <div class="col-sm-10">
                    <ui-date weekends="{{disableWeekends}}"></ui-date>
                  </div>
                <div class="col-sm-10 col-sm-offset-2">
                  <small ng-show="description" class="help-block text-muted custom-small">{{description}}</small>
                </div>
            </div>
            <div id="dashedline" class="hr-line-dashed"></div>
            """
        popoverTemplate: "<div></div>"

    # ----------------------------------------
    # text input
    # ----------------------------------------
    $builderProvider.registerComponent 'text',
        group: 'Basic'
        label: 'Text Input'
        description: ''
        placeholder: 'placeholder'
        readOnly: no
        minLength: 0
        maxLength: 999
        minRange: 0
        maxRange: 99999
        required: no
        validationOptions: [
            {label: 'None', rule: '/.*/'}
            {label: 'Text', rule: '[text]'}
            {label: 'Number', rule: '[numberRange]'}
        ]
        template:
            """
            <div class="row" id="{{formName+index | nospace}}">
                <label class="col-sm-2 control-label" for="{{formName+index}}" ng-class="{'fb-required':required}"><i ng-if ="formObject.logic.component" id="hasLogic" class="fa fa-random label-logic"></i> {{label}}</label>
                <div class="col-sm-10">
                    <input type="text" ng-show="validation != '[numberRange]'" ng-readonly="readOnly" ng-model="inputText" validator-required="{{required}}" validator-group="{{formName}}" class="form-control m-b" placeholder="{{placeholder}}"/>
                    <input type="tel" ng-show="validation === '[numberRange]'" ng-readonly="readOnly" ng-model="inputText" validator-required="{{required}}" validator-group="{{formName}}" class="form-control m-b" placeholder="{{placeholder}}"/>
                </div>
              <div class="col-sm-10 col-sm-offset-2">
                <small ng-show="description" class="help-block text-muted custom-small">{{description}}</small>
              </div>
            </div>
            <div id="dashedline" class="hr-line-dashed"></div>
            """
        popoverTemplate: "<div></div>"

    # ----------------------------------------
    # Text area
    # ----------------------------------------
    $builderProvider.registerComponent 'area',
        group: 'Basic'
        label: 'Text Area'
        description: ''
        placeholder: 'placeholder'
        required: no
        readOnly: no
        template:
            """
            <div class="row" id="{{formName+index | nospace}}">
                <label class="col-sm-2 control-label" for="{{formName+index}}" ng-class="{'fb-required':required}"><i ng-if ="formObject.logic.component" id="hasLogic" class="fa fa-random label-logic"></i> {{label}}</label>
                <div class="col-sm-10">
                    <textarea type="text" ng-readonly="readOnly" ng-model="inputText" validator-required="{{required}}" validator-group="{{formName}}" class="form-control m-b" rows='6' placeholder="{{placeholder}}"/>
                </div>
                <div class="col-sm-10 col-sm-offset-2">
                  <small ng-show="description" class="help-block text-muted custom-small">{{description}}</small>
                </div>
            </div>
            <div id="dashedline" class="hr-line-dashed"></div>
            """
        popoverTemplate: "<div></div>"

    # ----------------------------------------
    # checkbox
    # ----------------------------------------
    $builderProvider.registerComponent 'checkbox',
        group: 'Choice'
        label: 'Checkbox'
        description: ''
        placeholder: 'placeholder'
        required: no
        options: ['value one', 'value two']
        arrayToText: yes
        readOnly: no
        template:
            """
            <div class="row" id="{{formName+index | nospace}}">
                <label for="{{formName+index}}" class="col-sm-2 control-label" ng-class="{'fb-required':required}"><i ng-if ="formObject.logic.component" id="hasLogic" class="fa fa-random label-logic"></i> {{label}}</label>
                <div class="col-sm-10">
                    <input type='hidden' ng-model="inputText" validator-required="{{required}}" validator-group="{{formName}}"/>
                    <div class='checkbox icheck-label' ng-repeat="item in options track by $index">
                      <input id="{{formName+index+'_'+$index | nospace}}" ng-model="inputArray[$index]" ng-value='item' ng-disabled="readOnly" type="checkbox" checked="">
                      <label for="{{formName+index+'_'+$index | nospace}}">{{item}}</label>
                    </div>
                </div>
                <div class="col-sm-10 col-sm-offset-2">
                  <small ng-show="description" class="help-block text-muted custom-small">{{description}}</small>
                </div>
            </div>
            <div id="dashedline" class="hr-line-dashed"></div>
            """
        popoverTemplate: "<div></div>"

    # ----------------------------------------
    # radio
    # ----------------------------------------
    $builderProvider.registerComponent 'radio',
        group: 'Choice'
        label: 'Radio'
        description: ''
        placeholder: 'placeholder'
        required: no
        readOnly: no
        options: ['value one', 'value two']
        template:
            """
            <div class="row" id="{{formName+index | nospace}}">
                <label for="{{formName+index}}" class="col-sm-2 control-label" ng-class="{'fb-required':required}"><i ng-if ="formObject.logic.component" id="hasLogic" class="fa fa-random label-logic"></i> {{label}}</label>
                <div class="col-sm-10">
                    <div class='radio icheck-label' ng-repeat="item in options track by $index">

                        <input id="{{formName+index+'_'+$index | nospace}}" type="radio" ng-disabled="readOnly" name='{{formName+index}}' ng-model="$parent.inputText" validator-group="{{formName}}" ng-value='item'>
                        <label for="{{formName+index+'_'+$index | nospace}}">{{item}}</label>

                    </div>
                </div>
                <div class="col-sm-10 col-sm-offset-2">
                  <small ng-show="description" class="help-block text-muted custom-small">{{description}}</small>
                </div>
            </div>
            <div id="dashedline" class="hr-line-dashed"></div>
            """
        popoverTemplate: "<div></div>"

    # ----------------------------------------
    # select
    # ----------------------------------------
    $builderProvider.registerComponent 'select',
        group: 'Choice'
        label: 'Select'
        description: ''
        placeholder: 'Choose..'
        required: no
        readOnly: no
        options: ['value one', 'value two']
        template:
            """
            <div class="row" id="{{formName+index | nospace}}">
                <label class="col-sm-2 control-label" for="{{formName+index}}" ng-class="{'fb-required':required}"><i ng-if ="formObject.logic.component" id="hasLogic" class="fa fa-random label-logic"></i> {{label}}</label>
                <div class="col-sm-10 dropdown">
                    <select ng-show="!multiple" ng-readonly="readOnly" ng-options="value for value in options" class="form-control m-b"
                        ng-model="inputText" ng-init="inputText = ''">
                        <option value="">{{placeholder}}</option>
                    </select>
                </div>
                <div class="col-sm-10 col-sm-offset-2">
                  <small ng-show="description" class="help-block text-muted custom-small">{{description}}</small>
                </div>
            </div>
            <div id="dashedline" class="hr-line-dashed"></div>
            """
        popoverTemplate: "<div></div>"

        # ----------------------------------------
        # Address field
        # ----------------------------------------
        $builderProvider.registerComponent 'address',
            group: 'Advanced'
            label: 'Address Field'
            description: ''
            required: no
            readOnly: no
            placeholder: {
              StreetName: 'Street Name',
              Number: 'Number',
              Letter: 'Letter',
              Floor: 'Floor',
              PlaceName: 'Place Name',
              PostCode: 'Post Code',
              City: 'City'
            }
            options: []
            template:
                """
                <div class="row" id="{{formName+index | nospace}}">
                    <label class="col-sm-2 control-label" for="{{formName+index}}" ng-class="{'fb-required':required}"><i ng-if ="formObject.logic.component" id="hasLogic" class="fa fa-random label-logic"></i> {{label}}</label>
                    <div class="col-sm-10">
                        <input type="text" ng-readonly="readOnly" ng-model="inputText.StreetName" class="form-control custom-m-b" placeholder="{{placeholder.StreetName}}"/>
                        <input type="tel" ng-readonly="readOnly" ng-model="inputText.Number" class="form-control custom-m-b" placeholder="{{placeholder.Number}}"/>
                        <input type="text" ng-readonly="readOnly" ng-model="inputText.Letter" class="form-control custom-m-b" placeholder="{{placeholder.Letter}}"/>
                        <input type="text" ng-readonly="readOnly" ng-model="inputText.Floor" class="form-control custom-m-b" placeholder="{{placeholder.Floor}}"/>
                        <input type="text" ng-readonly="readOnly" ng-model="inputText.PlaceName" class="form-control custom-m-b" placeholder="{{placeholder.PlaceName}}"/>
                        <input type="text" ng-readonly="readOnly" ng-model="inputText.PostCode" class="form-control custom-m-b" placeholder="{{placeholder.PostCode}}"/>
                        <input type="text" ng-readonly="readOnly" ng-model="inputText.City" class="form-control m-b" placeholder="{{placeholder.City}}" validator-required={{required}} validator-group={{formName}}/>
                    </div>
                    <div class="col-sm-10 col-sm-offset-2">
                        <small ng-show="description" class="help-block text-muted custom-small">{{description}}</small>
                    </div>
                </div>
                <div id="dashedline" class="hr-line-dashed"></div>
                """
            popoverTemplate: "<div></div>"

            $builderProvider.registerComponent 'signature',
                group: 'Advanced'
                label: 'Signature Pad'
                decription: 'description'
                required: no
                readOnly: no
                template:
                    """
                    <div class="row" id="{{formName+index | nospace}}">
                        <label class="col-sm-2 control-label" for="{{formName+index}}" ng-class="{'fb-required':required}"><i ng-if ="formObject.logic.component" id="hasLogic" class="fa fa-random label-logic"></i> {{label}}</label>

                        <div class="col-sm-10">
                            <div class="m-b">
                                <signature-pad></signature-pad>
                            </div>
                        </div>
                        <div class="col-sm-10 col-sm-offset-2">
                            <small ng-show="description" class="help-block text-muted custom-small">{{description}}</small>
                        </div>
                    </div>
                    <div id="dashedline" class="hr-line-dashed"></div>
                    """
                popoverTemplate: "<div></div>"
]
