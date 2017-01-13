device = null;

function connect() {
  device = navigator.bluetooth.requestDevice({ filters: [{ name: ['LED'] }], optionalServices: [0xA000] })
    .then(device => device.gatt.connect())
    .then(server => server.getPrimaryService(0xA000))
    .then(service => service.getCharacteristic(0xA001))
}

function changeState(led_status) {
    device.then(characteristic => {
      // Writing 1 is the signal to reset energy expended.
      var led_status_array = new Uint8Array([led_status]);
      characteristic.writeValue(led_status_array);
    })
    .then(characteristic => {
      console.log('led state is ' + (!!parseInt(led_status,10) ? 'OFF' : 'ON'));
      // device.then(characteristic => {
      //   characteristic.readValue().then(value => {
      //     console.log(value.getUint16(0, true /* Little Endian */));
      //   });
      // });
    })
    .catch(error => {
      console.log(error);
    })

}