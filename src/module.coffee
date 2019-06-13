angular.module 'builder', ['builder.directive']
    .run ($validator) ->
        $validator.register('text', {
                invoke: 'watch'
                validator: (value, scope, element, attrs, $injector) ->
                    scope.minLength is 0 || (value.length >= scope.minLength && value.length <= scope.maxLength)
            })
        $validator.register('numberRange', {
                invoke: 'watch'
                validator: (value, scope, element, attrs, $injector) ->
                    value >= scope.minRange && value <= scope.maxRange
            })
