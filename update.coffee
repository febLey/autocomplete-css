# Run this to update the static list of properties stored in the properties.json
# file at the root of this repository.

path = require 'path'
fs = require 'fs'
request = require 'request'

requestOptions =
  url: 'https://raw.githubusercontent.com/adobe/brackets/master/src/extensions/default/CSSCodeHints/CSSProperties.json'
  json: true

request requestOptions, (error, response, properties) ->
  if error?
    console.error(error.message)
    return process.exit(1)

  if response.statusCode isnt 200
    console.error("Request for CSSProperties.json failed: #{response.statusCode}")
    return process.exit(1)

  pseudoSelectors = JSON.parse(fs.readFileSync(path.join(__dirname, 'pseudo-selectors.json')))
  completions = {properties, pseudoSelectors}
  fs.writeFileSync(path.join(__dirname, 'completions.json'), "#{JSON.stringify(completions, null, 0)}\n")
