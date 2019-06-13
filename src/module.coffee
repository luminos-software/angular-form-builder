angular.module 'builder', ['builder.directive']
    .run ($validator) ->
        $validator.register('text', {
                invoke: 'watch'
                validator: (value, scope, element, attrs, $injector) ->
                    scope.minLength is 0 || (value.length >= scope.minLength && value.length <= scope.maxLength)
            })
        $validator.register('sortCode', {
                invoke: 'watch'
                validator: (value, scope, element, attrs, $injector) ->
                    scope.minSortCodeLength is 0 || (value.length >= scope.minSortCodeLength && value.length <= scope.maxSortCodeLength)
            })
        $validator.register('accountNumber', {
                invoke: 'watch'
                validator: (value, scope, element, attrs, $injector) ->
                    scope.minAccountNumberLength is 0 || (value.length >= scope.minAccountNumberLength && value.length <= scope.maxAccountNumberLength)
            })
        $validator.register('numberRange', {
                invoke: 'watch'
                validator: (value, scope, element, attrs, $injector) ->
                    value >= scope.minRange && value <= scope.maxRange
            })
