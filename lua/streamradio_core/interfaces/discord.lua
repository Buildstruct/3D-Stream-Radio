local RADIOIFACE = RADIOIFACE
if not istable(RADIOIFACE) then
	StreamRadioLib.ReloadAddon()
	return
end

RADIOIFACE.name = "Discord"
RADIOIFACE.priority = 500
RADIOIFACE.online = true
RADIOIFACE.cache = false

RADIOIFACE.downloadTimeout = 5
RADIOIFACE.downloadFirst = true
RADIOIFACE.allowCaching = true

local ERROR_NO_PATH = 130000

StreamRadioLib.Error.AddStreamErrorCode({
	id = ERROR_NO_PATH,
	name = "STREAM_ERROR_DISCORD_NO_PATH",
	description = "[Discord] Url has no path",
	helptext = [[
Make sure your Discord url has a valid path in it.
]],
})

--cdn is discord's audio domain or something like that, you can probably trust these links. bonyo can you double check me
function RADIOIFACE:checkURL(url)
    local valid = string.StartsWith(url, 'https://cdn.discordapp.com/attachments')
    if not valid then return end

    local path = string.sub(url, 39)
    return path
end

local g_discord_content_url = "https://cdn.discordapp.com/";

function RADIOIFACE:Convert(url, callback)
	local path = self:ParseURL(url)

	if not path then
		callback(self, false, nil, ERROR_NO_PATH)
		return
	end

	local streamUrl = g_drive_content_url .. path

	streamUrl = StreamRadioLib.Url.URIAddParameter(streamUrl, {
		dl = 1,
	})

	callback(self, true, streamUrl)
end

return true

