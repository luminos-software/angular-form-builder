
# ----------------------------------------
# builder.directive
# ----------------------------------------
angular.module 'builder.directive', [
    'builder.provider'
    'builder.controller'
    'builder.drag'
    'validator'
]

# ----------------------------------------
# rich text directive
# ----------------------------------------
.directive 'richText', ['$injector', ($injector) ->
  restrict: 'E',
  link: (scope, elem, attrs) ->
    scope.text = scope.placeholder
    scope.$watch('placeholder', ->
        scope.text = scope.placeholder
      )

    scope.$watch('text', ->
      unless scope.text is 'Rich Content'
        elem[0].innerHTML = scope.text
      )
]

.filter 'nospace', ->
  (input) ->
    if input? and angular.isString(input)
      input.replace(/[^A-Z0-9]/ig, "")

.filter 'predicate', ->
  (input) ->
    switch input
      when 'eq'
        input = 'Equals'
      when 'not_eq'
        input = 'Does not equal'
      when 'matches'
        input = 'Matches'
      when 'does_not_match'
        input = 'Does not match'
      when 'contains'
        input = 'Contains'
      when 'does_not_contain'
        input = 'Does not contain'
      when 'lt'
        input = 'Less than'
      when 'lteq'
        input = 'Less than or equal to'
      when 'gt'
        input = 'Greater than'
      when 'gteq'
        input = 'Greater than or equal to'
      when 'not_in'
        input = 'Not in'
      when 'not_null'
        input = 'is Not Empty'
      when 'null'
        input = 'is Empty'
    return input

# ----------------------------------------
# date picker directive
# ----------------------------------------
.directive 'uiDate', ['$injector', ($injector) ->
    restrict: 'E'
    template:
        """
        <p class="input-group">
          <input type="text" class="form-control" max-date="maxDate" datepicker-popup="{{format}}" ng-model="inputText" is-open="opened" min-date="minDate" datepicker-options="dateOptions" date-disabled="disabled(date, mode)" close-text="Close"  validator-required="{{required}}" validator-group="{{required}}" id="{{formName+index}}" disabled/>
          <span class="input-group-btn">
            <button ng-disabled="readOnly" type="button" class="btn btn-default" ng-click="open($event)"><i class="glyphicon glyphicon-calendar"></i></button>
          </span>
        </p>
        """
    link: (scope, element, attrs) ->

        scope.inputText = ''

        scope.open = ($event) ->
            $event.preventDefault()
            $event.stopPropagation()
            scope.opened = yes

        extendPastWeekend = (from, daysOffset) ->
            dayInRange = moment();
            count = 0;
            for i in [0..daysOffset]
                if dayInRange.isoWeekday() == 6 || dayInRange.isoWeekday() == 7
                    count++;
                dayInRange.add(1, 'days');
            moment(from).add(count, 'days').format('YYYY-MM-DD')

        if scope.dateRangeStart
            scope.minDate = moment().add(scope.dateRangeStart, 'days').format('YYYY-MM-DD')
        else
            scope.minDate = moment().format('YYYY-MM-DD')

        if scope.dateRangeEnd
            scope.maxDate = moment().add(scope.dateRangeEnd, 'days').format('YYYY-MM-DD')

        if scope.disableWeekends
            if scope.dateRangeStart
                scope.minDate = extendPastWeekend(scope.minDate, scope.dateRangeStart);
            if scope.dateRangeEnd
                scope.maxDate = extendPastWeekend(scope.maxDate, scope.dateRangeEnd);
            scope.disabled = (date, mode) ->
                mode is 'day' && ( date.getDay() is 0 || date.getDay() is 6 )
        else
            scope.disabled = (date, mode) ->
]

# ----------------------------------------
# fb-builder
# ----------------------------------------
.directive 'fbBuilder', ['$injector', ($injector) ->
    # providers
    $builder = $injector.get '$builder'
    $drag = $injector.get '$drag'

    restrict: 'A'
    scope:
        fbBuilder: '@'
    template:
        """
        <div class='form-horizontal'>
            <div class='fb-form-object-editable' ng-repeat="object in formObjects"
                fb-form-object-editable="object"></div>
        </div>
        """
    link: (scope, element, attrs) ->
        # ----------------------------------------
        # valuables
        # ----------------------------------------
        scope.formName = attrs.fbBuilder
        $builder.forms[scope.formName] ?= []
        scope.formObjects = $builder.forms[scope.formName]
        beginMove = yes

        $(element).addClass 'fb-builder'
        $drag.droppable $(element),
            move: (e) ->
                if beginMove
                    # hide all popovers
                    $("div.fb-form-object-editable").popover 'hide'
                    beginMove = no

                $formObjects = $(element).find '.fb-form-object-editable:not(.empty,.dragging)'
                if $formObjects.length is 0
                    # there are no components in the builder.
                    if $(element).find('.fb-form-object-editable.empty').length is 0
                        $(element).find('>div:first').append $("<div class='fb-form-object-editable empty'></div>")
                    return

                # the positions could added .empty div.
                positions = []
                # first
                positions.push -1000
                for index in [0...$formObjects.length] by 1
                    $formObject = $($formObjects[index])
                    offset = $formObject.offset()
                    height = $formObject.height()
                    positions.push offset.top + height / 2
                positions.push positions[positions.length - 1] + 1000   # last

                # search where should I insert the .empty
                for index in [1...positions.length] by 1
                    if e.pageY > positions[index - 1] and e.pageY <= positions[index]
                        # you known, this one
                        $(element).find('.empty').remove()
                        $empty = $ "<div class='fb-form-object-editable empty'></div>"
                        if index - 1 < $formObjects.length
                            $empty.insertBefore $($formObjects[index - 1])
                        else
                            $empty.insertAfter $($formObjects[index - 2])
                        break
                return
            out: ->
                if beginMove
                    # hide all popovers
                    $("div.fb-form-object-editable").popover 'hide'
                    beginMove = no

                $(element).find('.empty').remove()
            up: (e, isHover, draggable) ->
                beginMove = yes
                if not $drag.isMouseMoved()
                    # click event
                    $(element).find('.empty').remove()
                    return

                if not isHover and draggable.mode is 'drag'
                    # remove the form object by draggin out
                    formObject = draggable.object.formObject
                else if isHover
                    if draggable.mode is 'mirror'
                        # insert a form object
                        $builder.insertFormObject scope.formName, $(element).find('.empty').index('.fb-form-object-editable'),
                            component: draggable.object.componentName
                    if draggable.mode is 'drag'
                        # update the index of form objects
                        oldIndex = draggable.object.formObject.index
                        newIndex = $(element).find('.empty').index('.fb-form-object-editable')
                        newIndex-- if oldIndex < newIndex
                        $builder.updateFormObjectIndex scope.formName, oldIndex, newIndex
                $(element).find('.empty').remove()
]

# ----------------------------------------
# fb-form-object-editable
# ----------------------------------------
.directive 'fbFormObjectEditable', ['$injector', ($injector) ->
    # providers
    $builder = $injector.get '$builder'
    $drag = $injector.get '$drag'
    $compile = $injector.get '$compile'
    $validator = $injector.get '$validator'

    restrict: 'A'
    controller: 'fbFormObjectEditableController'
    scope:
        formObject: '=fbFormObjectEditable'
    link: (scope, element) ->
        scope.inputArray = [] # just for fix warning
        # get component
        scope.$component = $builder.components[scope.formObject.component]
        # setup scope
        scope.setupScope scope.formObject

        # compile formObject
        scope.$watch '$component.template', (template) ->
            return if not template
            view = $compile(template) scope
            $(element).html view

        # disable click event
        $(element).on 'click', -> no

        # draggable
        $drag.draggable $(element),
            object:
                formObject: scope.formObject

        # do not setup bootstrap popover
        return if not scope.formObject.editable

        # ----------------------------------------
        # bootstrap popover
        # ----------------------------------------
        popover = {}
        scope.$watch '$component.popoverTemplate', (template) ->
            return if not template
            $(element).removeClass popover.id
            popover =
                id: "fb-#{Math.random().toString().substr(2)}"
                isClickedSave: no # If didn't click save then rollback
                view: null
                html: template
            popover.html = $(popover.html).addClass popover.id
            # compile popover
            popover.view = $compile(popover.html) scope
            $(element).addClass popover.id
            $(element).popover
                html: yes
                title: scope.$component.label
                content: popover.view
                container: 'body'
                placement: $builder.config.popoverPlacement
        scope.popover =
            save: ($event) ->
                ###
                The save event of the popover.
                ###
                $event.preventDefault()
                $validator.validate(scope).success ->
                    popover.isClickedSave = yes
                    $(element).popover 'hide'
                return
            remove: ($event) ->
                ###
                The delete event of the popover.
                ###
                $event.preventDefault()

                $builder.removeFormObject scope.$parent.formName, scope.$parent.$index
                $(element).popover 'hide'
                return
            shown: ->
                ###
                The shown event of the popover.
                ###
                scope.data.backup()
                popover.isClickedSave = no
            cancel: ($event) ->
                ###
                The cancel event of the popover.
                ###
                scope.data.rollback()
                if $event
                    # clicked cancel by user
                    $event.preventDefault()
                    $(element).popover 'hide'
                return
        # ----------------------------------------
        # popover.show
        # ----------------------------------------
        $(element).on 'show.bs.popover', ->
            return no if $drag.isMouseMoved()
            # hide other popovers
            $("div.fb-form-object-editable:not(.#{popover.id})").popover 'hide'

            $popover = $("form.#{popover.id}").closest '.popover'
            if $popover.length > 0
                # fixed offset
                elementOrigin = $(element).offset().top + $(element).height() / 2
                popoverTop = elementOrigin - $popover.height() / 2
                $popover.css
                    position: 'absolute'
                    top: popoverTop

                $popover.show()
                setTimeout ->
                    $popover.addClass 'in'
                    $(element).triggerHandler 'shown.bs.popover'
                , 0
                no
        # ----------------------------------------
        # popover.shown
        # ----------------------------------------
        $(element).on 'shown.bs.popover', ->
            # select the first input
            $(".popover .#{popover.id} input:first").select()
            scope.$apply -> scope.popover.shown()
            return
        # ----------------------------------------
        # popover.hide
        # ----------------------------------------
        $(element).on 'hide.bs.popover', ->
            # do not remove the DOM
            $popover = $("form.#{popover.id}").closest '.popover'
            if not popover.isClickedSave
                # eval the cancel event
                if scope.$$phase or scope.$root.$$phase
                    scope.popover.cancel()
                else
                    scope.$apply -> scope.popover.cancel()
            $popover.removeClass 'in'
            setTimeout ->
                $popover.hide()
            , 300
            no
]

.directive 'componentSelector', ['$injector', ($injector) ->
  $builder = $injector.get '$builder'
  restrict: 'E'
  template:
    """
    <select ng-model="formObject.logic.component" class="form-control custom-m-b">
      <optgroup ng-repeat="(groupName, items) in fields()" label="{{'Page: ' + groupName}}">
          <option ng-selected="item.id === componentize(formObject.logic.component)" ng-if="keys.indexOf(groupName) < keys.indexOf(currentForm) || (keys.indexOf(groupName) === keys.indexOf(currentForm) && item.index < formObject.index)" ng-repeat="item in fields()[groupName]" value="{{item}}">{{item.component}} - {{item.label}}</option>
      </optgroup>
    </select>
    """
  link: (scope, elem, attrs) ->
    scope.fields = () ->
      if elem.parent().parent().parent().parent().parent().is(':visible') is true
        $builder.forms
      else
        []

    scope.componentize = (component) ->
      if component?
        return angular.fromJson(component).id

]

# ----------------------------------------
# fb-components
# ----------------------------------------
.directive 'fbComponents', ->
    restrict: 'A'
    template:
        """
        <ul ng-if="groups.length > 1" class="nav nav-tabs nav-justified">
            <li ng-repeat="group in groups" ng-class="{active:activeGroup==group}">
                <a href='#' ng-click="selectGroup($event, group)">{{group}}</a>
            </li>
        </ul>
        <div class='form-horizontal'>
            <div class='fb-component' ng-repeat="component in components"
                fb-component="component"></div>
        </div>
        """
    controller: 'fbComponentsController'

# ----------------------------------------
# fb-component
# ----------------------------------------
.directive 'fbComponent', ['$injector', ($injector) ->
    # providers
    $builder = $injector.get '$builder'
    $drag = $injector.get '$drag'
    $compile = $injector.get '$compile'

    restrict: 'A'
    scope:
        component: '=fbComponent'
    controller: 'fbComponentController'
    link: (scope, element) ->
        scope.copyObjectToScope scope.component

        $drag.draggable $(element),
            mode: 'mirror'
            defer: no
            object:
                componentName: scope.component.name

        scope.$watch 'component.template', (template) ->
            return if not template
            view = $compile(template) scope
            $(element).html view
]

# ----------------------------------------
# signature pad
# ----------------------------------------
.directive 'signaturePad', ['$injector', ($injector) ->
  restrict: 'E'
  template: '<form method="post" action="" class="">
      <canvas class="pad" width="198" height="100" style="border: 1px solid black"></canvas>
      <input type="text" ng-model="inputText"  name="output" class="output" id="{{formName+index}}" hidden>
    <div class col-lg-12 no-padding m-t-xs"><button type="button" ng-click="clearSig()" class="btn btn-danger btn-sm"><i class="fa fa-refresh"></i></button></div>
    </form>'
  link: (scope, elem, attrs) ->

    scope.clearSig = ->
      scope.inputText = ''
      sigPad.regenerate()

    saveSig = ->
      scope.$apply(->
          scope.inputText = sigPad.getSignatureString()
        )
    # scope.$watch('readOnly', ->
    #     unless scope.readOnly is undefined
    #       if scope.readOnly
    #         sigPad.updateOptions({displayOnly: true})
    #       else
    #         sigPad.updateOptions({displayOnly: false})
    #   )
    sigPad = elem.signaturePad({drawOnly: true, lineColour: '#fff', onDrawEnd: saveSig})


]
# ----------------------------------------
# fb-multiple
# ----------------------------------------
.directive 'fbMultiple', ['$injector', ($injector) ->
    $builder = $injector.get '$builder'

    restrict: 'E'
    scope: {array: '='}
    templateUrl: 'src/ngMultiple.html'
    link: (scope, element, attrs) ->
        scope.seeForms = ->
            console.log $builder.forms
        scope.select = (item) ->
            scope.selected = item
        scope.addPage = ->
            scope.array.push(scope.array.length + 1)
]

# ----------------------------------------
# fb-form
# ----------------------------------------
.directive 'fbForm', ['$injector', ($injector) ->
    restrict: 'A'
    require: 'ngModel'  # form data (end-user input value)
    scope:
        # input model for scops in ng-repeat
        formName: '@fbForm'
        input: '=ngModel'
        default: '=fbDefault'
    template:
        """
        <div class='fb-form-object' ng-repeat="object in form" fb-form-object="object"></div>
        """
    controller: 'fbFormController'
    link: (scope, element, attrs) ->
        # providers
        $builder = $injector.get '$builder'

        # get the form for controller
        $builder.forms[scope.formName] ?= []
        scope.form = $builder.forms[scope.formName]
]

# ----------------------------------------
# fb-form-object
# ----------------------------------------
.directive 'fbFormObject', ['$injector', ($injector) ->
    # providers
    $builder = $injector.get '$builder'
    $compile = $injector.get '$compile'
    $parse = $injector.get '$parse'

    restrict: 'A'
    controller: 'fbFormObjectController'
    link: (scope, element, attrs) ->
        # ----------------------------------------
        # variables
        # ----------------------------------------
        scope.formObject = $parse(attrs.fbFormObject) scope
        scope.$component = $builder.components[scope.formObject.component]

        # ----------------------------------------
        # scope
        # ----------------------------------------
        # listen (formObject updated
        scope.$on $builder.broadcastChannel.updateInput, -> scope.updateInput scope.inputText
        if scope.$component.arrayToText
            scope.inputArray = []
            # watch (end-user updated input of the form
            scope.$watch 'inputArray', (newValue, oldValue) ->
                # array input, like checkbox
                return if newValue is oldValue
                checked = []
                for index of scope.inputArray when scope.inputArray[index]
                    unless index is 'diff'
                      checked.push scope.options[index] ? scope.inputArray[index]
                scope.inputText = checked
            , yes
        scope.$watch 'inputText', -> scope.updateInput scope.inputText
        # watch (management updated form objects
        scope.$watch attrs.fbFormObject, ->
            scope.copyObjectToScope scope.formObject
        , yes

        scope.$watch '$component.template', (template) ->
            return if not template
            $template = $(template)
            # add validator
            $input = $template.find "[ng-model='inputText']"
            $input.attr
                validator: '{{validation}}'
            # compile
            view = $compile($template) scope
            $(element).html view

        # select the first option
        if not scope.$component.arrayToText and scope.formObject.options.length > 0
            scope.inputText = scope.formObject.options[0]

        # set default value
        scope.$watch "default['#{scope.formObject.id}']", (value) ->
            return if not value
            if scope.$component.arrayToText
                scope.inputArray = value
            else
                scope.inputText = value
]

.directive 'uploadPhoto', ->
  restrict: 'A'
  link: (scope, element, attrs) ->
    angular.element('#uploadBtn').onchange = ->
      angular.element('#uploadFile').value = this.value
