# Webbluetooth + nrf52DK experiment page

## nrf52DK

### LEDs meaning

 - LED1 vitality, indicates that the MCU is running
 - LED2 is the LED controlled (write) from the web page
 - LED3 reflects the BUTTON1 it's ON if the button is released and it's off when pressed

### Buttons

 - BUTTON1 is able to send from the device to the browser its state

### Firmware stack

The firmware uses the mbedOS5 environment and it's compiled with the mbed-cli.
for compile run

```Bash
mbed compile -t GCC_ARM -m NRF52_DK
```

### Bluetooth architecture

The are two **services** the *Button* and the *LED* service. Each service has its own .h file. For example the ButtonService.h file contains both the BUTTON_SERVICE_UUID and the BUTTON_STATE_CHARACTERISTIC_UUID.

```C
const static uint16_t BUTTON_SERVICE_UUID              = 0xB000;
const static uint16_t BUTTON_STATE_CHARACTERISTIC_UUID = 0xB001;
```

## Web test page

the web page uses the Riotjs framework. Riotjs use tags file (components) which needs to be compiled by the riotjs compiler

```Bash
riot --watch .
```

Serve it
```Bash
live-server .
```