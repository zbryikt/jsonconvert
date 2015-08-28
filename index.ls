
angular.module \main, <[]>
  ..controller \main, <[$scope]> ++ ($scope) ->
    $scope.build = ->
      blob = new Blob([$scope.csv],type:'text/csv')
      $scope.url = URL.createObjectURL blob
      $scope.download = "output"
      set-timeout (->$(\#download).attr("href",$scope.url)), 0

    $scope.convert = ->
      try
        $scope.download = null
        json = JSON.parse($scope.json)
        result = jsonconvert.toCSV json
        $scope.csv = result
        $scope.build!
      catch e
        $scope.csv = e.toString!
