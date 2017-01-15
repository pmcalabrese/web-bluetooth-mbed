# Webbluetooth + nrf52DK experiment page

## nrf52DK

### LEDs meaning

 - LED1 vitality, indicates that the MCU is running
 - LED2 is the LED controlled (write) from the web page
 - LED3 is the LED that reflect the BUTTON1 it's ON if the button is released and it's off if is pressed

### Buttons

 - BUTTON1 is able to send from the device to the browser its state

### Firmware stack

The firmware uses the mbedOS5 environment and it's combiled with the mbed-cli.

### Bluetooth architecutre

The are two **services** the *Button* and the *LED* service. Each service has its own .h file which contains both the BUTTON_SERVICE_UUID and the BUTTON_STATE_CHARACTERISTIC_UUID.

```C
    const static uint16_t BUTTON_SERVICE_UUID              = 0xB000;
    const static uint16_t BUTTON_STATE_CHARACTERISTIC_UUID = 0xB001;
```