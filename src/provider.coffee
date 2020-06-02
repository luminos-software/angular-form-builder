###
    component:
        It is like a class.
        The base components are textInput, textArea, select, check, radio.
        User can custom the form with components.
    formObject:
        It is like an object (an instance of the component).
        User can custom the label, description, required and validation of the input.
    form:
        This is for end-user. There are form groups int the form.
        They can input the value to the form.
###

angular.module 'builder.provider', []

.provider '$builder', ->
    $injector = null
    $http = null
    $templateCache = null

    @config =
        popoverPlacement: 'right'
        max_id: 0
    # all components
    @components = {}
    # all groups of components
    @groups = []
    @broadcastChannel =
        updateInput: '$updateInput'

    @skipLogicComponents = []

    # forms
    #   builder mode: `fb-builder` you could drag and drop to build the form.
    #   form mode: `fb-form` this is the form for end-user to input value.
    @forms = {}
        # skipLogic: []


    # ----------------------------------------
    # private functions
    # ----------------------------------------
    @convertComponent = (name, component) ->
        result =
            name: name
            group: component.group ? 'Default'
            label: component.label ? ''
            description: component.description ? ''
            placeholder: component.placeholder ? ''
            editable: component.editable ? yes
            required: component.required ? no
            validation: component.validation ? '/.*/'
            validationOptions: component.validationOptions ? []
            options: component.options ? []
            arrayToText: component.arrayToText ? no
            template: component.template
            templateUrl: component.templateUrl
            popoverTemplate: component.popoverTemplate
            popoverTemplateUrl: component.popoverTemplateUrl
        if not result.template and not result.templateUrl
            console.error "The template is empty."
        result

    @convertFormObject = (name, formObject={}) ->
        component = @components[formObject.component]
        throw "The component #{formObject.component} was not registered." if not component?
        result =
            id: formObject.id
            component: formObject.component
            editable: formObject.editable ? component.editable
            index: formObject.index ? 0
            label: formObject.label ? component.label
            description: formObject.description ? component.description
            placeholder: formObject.placeholder ? component.placeholder
            options: formObject.options ? component.options
            required: formObject.required ? component.required
            showExtraInfo2: formObject.showExtraInfo2 ? component.showExtraInfo2
            validation: formObject.validation ? component.validation
            multiple: formObject.multiple ? component.multiple
            minLength: formObject.minLength ? component.minLength
            maxLength: formObject.maxLength ? component.maxLength
            minSortCodeLength: formObject.minSortCodeLength ? component.minSortCodeLength
            maxSortCodeLength: formObject.maxSortCodeLength ? component.maxSortCodeLength
            minAccountNumberLength: formObject.minAccountNumberLength ? component.minAccountNumberLength
            maxAccountNumberLength: formObject.maxAccountNumberLength ? component.maxAccountNumberLength
            dateRangeStart: formObject.dateRangeStart ? component.dateRangeStart
            dateRangeEnd: formObject.dateRangeEnd ? component.dateRangeEnd
            disableWeekends: formObject.disableWeekends ? component.disableWeekends
            readOnly: formObject.readOnly ? component.readOnly
            nextXDays: formObject.nextXDays ? component.nextXDays
            maxDate: formObject.maxDate ? component.maxDate
            requireConfirmation: formObject.requireConfirmation ? component.requireConfirmation
            minRange: formObject.minRange ? component.minRange
            maxRange: formObject.maxRange ? component.maxRange
            performCreditCheck: formObject.performCreditCheck ? component.performCreditCheck
            creditCheckRequired: formObject.creditCheckRequired ? component.creditCheckRequired
            performMeterLookup: formObject.performMeterLookup ? component.performMeterLookup
            cprCountry: formObject.cprCountry ? component.cprCountry
            logic: formObject.logic ? component.logic
            category: formObject.category ? component.category
            conversionType: formObject.conversionType ? component.conversionType
            searchScope: formObject.searchScope ? component.searchScope
            searchPeriod: formObject.searchPeriod ? component.searchPeriod
            transformations: formObject.transformations ? component.transformations
            uploaderType: formObject.uploaderType ? component.uploaderType
            client: formObject.client ? component.client
            searchToken: formObject.searchToken ? component.searchToken
            requireHit: formObject.requireHit ? component.requireHit
            voucherCampaign: formObject.voucherCampaign ? component.voucherCampaign
            seasMonthlySubscriptionPrice: formObject.seasMonthlySubscriptionPrice ? component.seasMonthlySubscriptionPrice
            seasPricePerKwh: formObject.seasPricePerKwh ? component.seasPricePerKwh
        result

    @reindexFormObject = (name) =>
        formObjects = @forms[name]
        for index in [0...formObjects.length] by 1
            formObjects[index].index = index
        return

    @setupProviders = (injector) =>
        $injector = injector
        $http = $injector.get '$http'
        $templateCache = $injector.get '$templateCache'
        $modal = $injector.get '$modal'

    @loadTemplate = (component) ->
        ###
        Load template for components.
        @param component: {object} The component of $builder.
        ###
        if not component.template?
            $http.get component.templateUrl,
                cache: $templateCache
            .success (template) ->
                component.template = template
        if not component.popoverTemplate?
            $http.get component.popoverTemplateUrl,
                cache: $templateCache
            .success (template) ->
                component.popoverTemplate = template

    # ----------------------------------------
    # public functions
    # ----------------------------------------
    @registerComponent = (name, component={}) =>
        ###
        Register the component for form-builder.
        @param name: The component name.
        @param component: The component object.
            group: {string} The component group.
            label: {string} The label of the input.
            description: {string} The description of the input.
            placeholder: {string} The placeholder of the input.
            editable: {bool} Is the form object editable?
            required: {bool} Is the form object required?
            validation: {string} angular-validator. "/regex/" or "[rule1, rule2]". (default is RegExp(.*))
            validationOptions: {array} [{rule: angular-validator, label: 'option label'}] the options for the validation. (default is [])
            options: {array} The input options.
            arrayToText: {bool} checkbox could use this to convert input (default is no)
            template: {string} html template
            templateUrl: {string} The url of the template.
            popoverTemplate: {string} html template
            popoverTemplateUrl: {string} The url of the popover template.
        ###
        if not @components[name]?
            # regist the new component
            newComponent = @convertComponent name, component
            @components[name] = newComponent
            @loadTemplate(newComponent) if $injector?
            if newComponent.group not in @groups
                @groups.push newComponent.group
        else
            console.error "The component #{name} was registered."
        return

    @addFormObject = (name, formObject={}) =>
        ###
        Insert the form object into the form at last.
        ###
        @forms[name] ?= []
        @insertFormObject name, @forms[name].length, formObject

    @insertFormObject = (name, index, formObject={}) =>
        ###
        Insert the form object into the form at {index}.
        @param name: The form name.
        @param index: The form object index.
        @param form: The form object.
            id: The form object id.
            component: {string} The component name
            editable: {bool} Is the form object editable? (default is yes)
            label: {string} The form object label.
            description: {string} The form object description.
            placeholder: {string} The form object placeholder.
            options: {array} The form object options.
            required: {bool} Is the form object required? (default is no)
            validation: {string} angular-validator. "/regex/" or "[rule1, rule2]".
            [index]: {int} The form object index. It will be updated by $builder.
        @return: The form object.
        ###
        @forms[name] ?= []
        if index > @forms[name].length then index = @forms[name].length
        else if index < 0 then index = 0
        @forms[name].splice index, 0, @convertFormObject(name, formObject)
        @reindexFormObject name
        @forms[name][index]

    @removeFormObject = (name, index) =>
        ###
        Remove the form object by the index.
        @param name: The form name.
        @param index: The form object index.
        ###
        forms = @forms
        reindexFormObject = @reindexFormObject
        $modal = $injector.get '$modal'
        id = @forms[name][index].id
        elems = []
        for key,value of @forms
          value.forEach (elem) ->
            if elem.id isnt id and elem.logic and elem.logic.component and angular.fromJson(elem.logic.component).id is id
              elems.push elem
        if elems.length >= 0
          modal = $modal.open({
            template: """
            <div class="inmodal" auto-focus>
              <form ng-submit="$close()">
                <div class="modal-header">
                  <a type="button" class="close x-close" ng-click="$dismiss()"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></a>
                  <i class="fa fa-question modal-icon"></i>
                  <h4 class="modal-title">Delete Component?</h4>
                </div>
                <div class="modal-body text-center">
                  <p class="no-margins" ng-if="!elems.length"><b>Warning!</b><br>You are about to delete this element!</p>
                  <p class="no-margins" ng-if="elems.length"><b>Warning!</b><br>The following elements are logically dependent on the element you are trying to delete!</p>
                  <ul class="list-group m-t-md" ng-if="elems.length">
                    <li class="list-group-item list-group-item-warning" ng-repeat="elem in elems">
                      {{elem.label}}
                    </li>
                  </ul>
                </div>
                <div class="modal-footer">
                  <btn class="btn btn-default pull-left" ng-click="$dismiss()">Cancel</btn>
                  <input type="submit" class="btn btn-primary pull-right" value="OK"></input>
                </div>
              </form>
            </div>
            """,
            controller: ($scope, $modal) ->
              $scope.elems = elems
            elems: () ->
              elems
            })

          modal.result.then () ->
            elems.forEach (elem) ->
              elem.logic = {action: 'Hide'}
            formObjects = forms[name]
            formObjects.splice index, 1
            reindexFormObject name
        else
          formObjects = forms[name]
          formObjects.splice index, 1
          reindexFormObject name

    @updateFormObjectIndex = (name, oldIndex, newIndex) =>
        ###
        Update the index of the form object.
        @param name: The form name.
        @param oldIndex: The old index.
        @param newIndex: The new index.
        ###
        return if oldIndex is newIndex
        formObjects = @forms[name]
        formObject = formObjects.splice(oldIndex, 1)[0]
        formObjects.splice newIndex, 0, formObject
        @reindexFormObject name

    # ----------------------------------------
    # $get
    # ----------------------------------------
    @$get = ['$injector', ($injector) =>
        @setupProviders($injector)
        for name, component of @components
            @loadTemplate component

        config: @config
        components: @components
        groups: @groups
        forms: @forms
        broadcastChannel: @broadcastChannel
        registerComponent: @registerComponent
        addFormObject: @addFormObject
        insertFormObject: @insertFormObject
        removeFormObject: @removeFormObject
        updateFormObjectIndex: @updateFormObjectIndex
    ]
    return
