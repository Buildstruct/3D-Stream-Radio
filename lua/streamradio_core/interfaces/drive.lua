local RADIOIFACE = RADIOIFACE
if not istable(RADIOIFACE) then
	StreamRadioLib.ReloadAddon()
	return
end

RADIOIFACE.name = "Google Drive"
RADIOIFACE.priority = 200
RADIOIFACE.online = true
RADIOIFACE.cache = false

RADIOIFACE.downloadTimeout = 5
RADIOIFACE.downloadFirst = true
RADIOIFACE.allowCaching = true

local ERROR_NO_PATH = 130000

StreamRadioLib.Error.AddStreamErrorCode({
	id = ERROR_NO_PATH,
	name = "STREAM_ERROR_DRIVE_NO_PATH",
	description = "[Drive] Url has no path",
	helptext = [[
Make sure your Google Drive has a valid path in it.
]],
})
--https://drive.google.com/file/d/1DUEWr10qEdqEDshGbZywfxmu9LtaGPLW/view?usp=drive_link

local DropboxURLs = {
	"drive.google://",
	"//drive.google.com/",
}

function RADIOIFACE:CheckURL(url)
	for i, v in ipairs(DropboxURLs) do
		local result = string.find(string.lower(url), v, 1, true)

		if not result then
			continue
		end

		return true
	end

	return false
end


function RADIOIFACE:ParseURL(url)
    if not url then return end
    return string.match(url, '/d/([%w_-]+)')
end

local g_drive_content_url = "https://drive.google.com/uc?export=download&id=";

function RADIOIFACE:Convert(url, callback)
	local valid = self:CheckURL(url)
    if not valid then return end
    local path = self:ParseURL(url)
    if string.sub(url,#g_drive_content_url) == g_drive_content_url then
        path = url
    end

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

