# rdsc-x32-tap-tempo

Set the Stereo Delay effect's delay time on a networked Behringer X32 (or Midas M32) using a tap-tempo trigger in RD/ShowCockpit.

## Requirements

- [RD/ShowCockpit](https://showcockpit.com/) software

  - [Lua driver](https://showcockpit.com/site/docs/?d=45).
  - [Generic OSC driver](https://showcockpit.com/site/docs/?d=29).
  - Tap tempo button driver of your choice.

- X32 mixer, reachable over IP by ShowCockpit.

## Installation/Setup

### X32 setup

1. Ensure the X32 mixer is on a network and reachable from the computer running ShowCockpit.
2. Place a Stereo Delay effect in one of your effect rack slots, and note the slot number. For example, if Stereo Delay is your 2nd effect, the slot number is `2`.

### ShowCockpit setup

1. Add an instance of the _Generic OSC_ driver to your ShowCockpit project

  - The name you give the driver in your project list is important, so call it something you will remember, like "`X32`".
  - Enter the IP of the X32.
  - Enter `10023` as the outbound port number.
  - Enable the driver.

2. Add an instance of the _Lua_ driver to your ShowCockpit project

  - Name it something meaningful, like `X32 Tap Tempo`, for example.
  - Double click to edit the Lua script, and copy/paste the contents of the included _rdsc-x32-tap-tempo.lua_ file.
  - Edit the variable values in the top few lines of the script to reflect your setup:

    - _x32_element_ is the **exact** name you gave the Generic OSC driver in the ShowCockpit project.
    - _delay_slot_ is the effect position number of your Stereo Delay on the X32.
    - _max_taps_ is the number of tempo taps, after which averaging will cease and start over

3. In the mapping section of ShowCockpit, assign your Lua driver to a tap-tempo button of your choice.

## Usage

- Continuously tap the Lua-mapped button to the tempo of music.
- Beginning with the 2nd consecutive tap, the delay time between taps will be computed and sent to the mixer, setting the delay parameter accordingly.
- Each additional tap of the button will contribute toward a weighted average tempo (until the number of taps defined in _max_taps_ is reached and the average is reset), and the delay value on the mixer is subsequently updated.

Note: The X32's Stereo Delay has a maximum delay time of 3000ms. Therefore, if more than 3 seconds elapses between taps, the press will not be counted and the averaging process starts over.
