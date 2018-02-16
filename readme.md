# Webbluetooth + nrf52DK experiment page

Video of the project presentation - 30th May 2017 in London at CodeNode
https://skillsmatter.com/skillscasts/10356-webbluetooth-and-arm-mbed-enabled-platform

## nrf52DK

### LEDs meaning

 - LED1 vitality, indicates that the MCU is running
 - LED2 is the LED controlled (write) from the web page
 - LED3 reflects the BUTTON1 it's ON if the button is released and it's off when pressed

### Buttons meaning

 - BUTTON1 is able to send from the device to the browser its state

### Firmware stack

Install mbed-cli first follow theinstruction on this page https://github.com/ARMmbed/mbed-cli.
The firmware uses the mbedOS5 environment and it's compiled with the mbed-cli.
for compile run

from the folder *source* run

```Bash
mbed compile -t GCC_ARM -m NRF52_DK
```

After compile a BUILD folder will be created.
In the BUILD at this path NRF52_DK/GCC_ARM/mbed-os-example-ble-LED.hex there is the .hex file. Drop that file into the board (which will appear like and USB drive).

### Bluetooth architecture

The are two **services** the *Button* and the *LED* service. Each service has its own .h file. For example the ButtonService.h file contains both the BUTTON_SERVICE_UUID and the BUTTON_STATE_CHARACTERISTIC_UUID.

```C
const static uint16_t BUTTON_SERVICE_UUID              = 0xB000;
const static uint16_t BUTTON_STATE_CHARACTERISTIC_UUID = 0xB001;
```

## Web test page

### Install tools

```Bash
npm install riot riot-cli live-server -g
```

The web page uses the Riotjs framework. Riotjs use tags file (components) which needs to be compiled by the riot compiler

from the folder *webbluetooth_testpage* run

```Bash
riot --watch .
```

Now you serve the web app by running

```Bash
live-server .
```
