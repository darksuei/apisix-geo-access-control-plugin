local core = require("apisix.core");
local ngx = ngx;

local plugin_name = "geo-access-control"

local plugin_schema = {
    type = "object",
    properties = {
      allow = {
        type = "array",
        items = {
          type = "string",
          description = "List of allowed countries based on ISO 3166-1 alpha-2 country codes"
        },
        description = "Countries from which requests are allowed"
      },
      ban = {
        type = "array",
        items = {
          type = "string",
          description = "List of banned countries based on ISO 3166-1 alpha-2 country codes"
        },
        description = "Countries from which requests are banned"
      },
      ip_processing = {
        type = "object",
        properties = {
          enabled = {
            type = "boolean",
            default = true,
            description = "Enable or disable IP geolocation processing"
          },
          attach_geo_headers = {
            type = "boolean",
            default = true,
            description = "Attach geolocation data to request headers"
          }
        },
        additionalProperties = false,
        description = "IP processing settings for geolocation"
      },
    },
    additionalProperties = false,
}

local _M = {
    version = 1.0,
    priority = 2000,
    name = plugin_name,
    schema = plugin_schema,
}
  
-- Validate the schema configuration
function _M.check_schema(conf)
    local ok, err = core.schema.check(plugin_schema, conf)
    if not ok then
        return false, err
    end
    return true
  end

local function get_client_ip()
    local client_ip = ngx.var.remote_addr
    if not client_ip then
        return nil, "failed to get the client IP address"
    end
    return client_ip
end

function _M.access(conf, ctx)
  local client_ip, err = get_client_ip()
  core.log.info(tostring(client_ip))
  core.log.warn(err)
  io.write("Accessing the plugin\n")
end

return _M