local utils = require("new-file-template.utils")

local function base_template(relative_path, filename)
  return [[
</html>
<head>
  <title>[:EVAL:]expand('%:t:r')[:END:]</title>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width,initial-scale=1" />
  <meta name="description" content="" />
  <link rel="stylesheet" type="text/css" href="css/[:EVAL:]expand('%:t:r')[:END:].css" />
</head>

<body>
  <h1>[:EVAL:]expand('%:t:r')[:END:]</h1>
</body>

</html>
  ]]
end

--- @param opts table
---   A table containing the following fields:
---   - `full_path` (string): The full path of the new file, e.g., "lua/new-file-template/templates/init.lua".
---   - `relative_path` (string): The relative path of the new file, e.g., "lua/new-file-template/templates/init.lua".
---   - `filename` (string): The filename of the new file, e.g., "init.lua".
return function(opts)
  local template = {
    { pattern = ".*", content = base_template },
  }

	return utils.find_entry(template, opts)
end
