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
      ret.push [[k],idx++]
      if typeof(json.0[k]) == typeof({}) => 
        subfields = @build(json.0[k])
        for f in subfields => ret.push [[k] ++ f.0, idx++]
    return ret
  traverse: (json, fields, values, idx, ret) -> 
    if idx >= fields.length => 
      ret.push values.map(->if it => "\"#it\"" else "").join(",")
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
      return @traverse json, fields, values, idx + 1, ret
    if !Array.isArray(data) =>
      return @traverse json, fields, values, idx + 1, ret
    for item in data =>
      parent[key] = item
      @traverse json, fields, values, idx + 1, ret

  toCSV: (json) ->
    ret = []
    fields = @build(json)
    values = []
    for k in fields => values.push null
    ret.push fields.map(-> "\"#{it.0.join(" / ")}\"").join(",")
    @traverse json, fields, values, 0, ret
    return ret.join("\n")

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

module.exports = jsonconvert
