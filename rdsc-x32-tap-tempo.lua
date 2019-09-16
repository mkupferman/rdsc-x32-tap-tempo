-- CONFIGURATION --
x32_element = 'X32'
delay_slot = 2
max_taps = 12
-------------------

x32 = GetElement(x32_element)
delay_addr = '/fx/'..delay_slot..'/par/02'

-- tempo tap button pressed

-- need global non-volatile variables
last_tap = GetVar('last_tap'..x32_element)
delta_count = GetVar('delta_count'..x32_element)
avg_delay = GetVar('avg_delay'..x32_element)

if last_tap == nil then
    -- first time invoked; get time
    last_tap = os.clock()
    delta_count = 0
else
    tap = os.clock()
    tap_delta = tap - last_tap
    last_tap = tap
    delta_count = delta_count + 1

    if tap_delta < 3 and delta_count < max_taps then
        -- let's count this
        if delta_count == 1 then
            -- first tempo!
            avg_delay = tap_delta
        else
            -- add to moving avg
            avg_delay = avg_delay - avg_delay / delta_count + tap_delta / delta_count
            delay_pct = avg_delay / 3
            -- send to mixer
            x32.SendMessageFloat(delay_addr, delay_pct)
        end

    else
        -- start over
        delta_count = 0
    end

end

SetVar('last_tap'..x32_element, last_tap)
SetVar('delta_count'..x32_element, delta_count)
SetVar('avg_delay'..x32_element, avg_delay)
