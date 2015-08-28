jsonconvert = do
  find-array: (json) ->
    if Array.isArray(json) => return json
    if typeof(json) != typeof({}) => return null
    for k,v of json => if @find-array(v) => return that
    return [json]
  simpleCSV: (json) ->
    ret = ""
    json = @find-array json
    fields = {}
    for item in json => for k of item => fields[k] = 1
    fields = [k for k of fields]
    ret += (fields.map(->"\"#it\"").join(",") + "\n")
    for item in json =>
      ret += (fields.map(->"\"#{item[it]}\"").join(",") + "\n")
    ret

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
        result = jsonconvert.simpleCSV json
        $scope.csv = result
        $scope.build!
      catch e
        $scope.csv = e.toString!
