local dfpwm = require("cc.audio.dfpwm")
local speaker = peripheral.find("speaker")

local function playDFPWM(url)
    if not speaker then
        error("No speaker peripheral found")
    end

    local decoder = dfpwm.make_decoder()
    local handle = assert(http.get(url, nil, true))

    for chunk in handle.read, 16 * 1024 do
        local buffer = decoder(chunk)
        while not speaker.playAudio(buffer) do
            os.pullEvent("speaker_audio_empty")
        end
    end

    handle.close()

    while speaker.getAudioPlaying() do
        os.pullEvent("speaker_audio_empty")
    end
end

playDFPWM("https://your-website.example/file.dfpwm")
print("Playback finished!")
