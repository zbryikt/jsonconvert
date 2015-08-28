require! <[fs]>

json = JSON.parse(fs.read-file-sync \sample.json .toString!)

jsonconvert = do
  build: (json) ->
    if !Array.isArray(json) => json = [json]
    fields = {}
    idx = 1
    for item in json => for k,v of item => if !(fields[k]) => fields[k] = typeof(v)
    keys = [[k,v] for k,v of fields]
    idx = 1
    ret = []
    for [k,v] in keys => 
      #if v != typeof({}) => ret.push [[k],idx++]
      ret.push [[k],idx++]
      if typeof(json.0[k]) == typeof({}) => 
        subfields = @build(json.0[k])
        for f in subfields => ret.push [[k] ++ f.0, idx++]
    return ret
  traverse: (json, fields, values, idx) -> 
    if idx >= fields.length => 
      console.log values.map(->if it => "\"#it\"" else "").join(",")
      return
    field = fields[idx]
    key = null
    data = json
    for i from 0 til field.0.length
      parent = data
      data = data[field.0[i]]
      key = field.0[i]
    if typeof(data) != typeof({}) => 
      values[idx] = data
      return @traverse json, fields, values, idx + 1
    if !Array.isArray(data) =>
      return @traverse json, fields, values, idx + 1
    for item in data =>
      parent[key] = item
      @traverse json, fields, values, idx + 1

  toCSV: (json) ->
    fields = @build(json)
    values = []
    for k in fields => values.push null
    console.log fields.map(-> "\"#{it.0.join(" / ")}\"").join(",")
    @traverse json, fields, values, 0

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

jsonconvert.toCSV(json)

