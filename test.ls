require! <[fs]>
require! './index': jsonconvert
json = JSON.parse(fs.read-file-sync \sample.json .toString!)
console.log jsonconvert.toCSV(json)
