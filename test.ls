require! <[fs]>
require! './index': jsonconvert
json = JSON.parse(fs.read-file-sync \sample.json .toString!)
console.log jsonconvert.toCSV([{a:1,b:2},{a:3,b:4}])
console.log jsonconvert.toCSV([{a:<[1 2]>,b:<[3 4]>}])
console.log jsonconvert.toCSV([[1,2],[3,4],[5,6]])
# failed
console.log jsonconvert.toCSV(["一","二"])
#console.log jsonconvert.toCSV(json)
