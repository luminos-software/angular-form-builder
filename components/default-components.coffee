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


]
