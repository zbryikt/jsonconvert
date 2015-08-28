require! <[fs]>

json = JSON.parse(fs.read-file-sync \sample.json .toString!)

jsonconvert = do
  build: (json) ->
    if !Array.isArray(json) => json = [json]
    fields = {}
    idx = 1
    for item in json => for k of item => if !(fields[k]) => fields[k] = idx++
    keys = [k for k of fields]
    idx = 1
    ret = []
    for k in keys => 
      ret.push [[k],idx++]
      if typeof(json.0[k]) == typeof({}) => 
        subfields = @build(json.0[k])
        for f in subfields => ret.push [[k] ++ f.0, idx++]
    return ret
  traverse: (prefix, json, fields, values) -> 
    if !Array.isArray(json) => json = [json]
    for item in json =>
      for k of item =>

  toCSV: (json) ->
    fields = @build(json)
    console.log fields
    values = {}
    for k of fields => values[k] = ""
    @traverse "", json, values
  find-array: (json) ->
    if Array.isArray(json) => return json
    if typeof(json) != typeof({}) => return null
    for k,v of json => if @find-array(v) => return that
    return [json]
  simpleCSV: (json) ->
    json = @find-array json
    fields = {}
    for item in json => for k of item => fields[k] = 1
    fields = [k for k of fields]
    console.log fields.map(->"\"#it\"").join(",")
    for item in json =>
      console.log fields.map(->"\"#{item[it]}\"").join(",")

#jsonconvert.simpleCSV(json)

