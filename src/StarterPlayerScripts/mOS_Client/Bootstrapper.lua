local bootstrapper = {}
local modules = script.Parent.Modules
local ObjectHandler = require(modules.Core.ObjectHandler)
function bootstrapper:Init()
    ObjectHandler()
end

return bootstrapper