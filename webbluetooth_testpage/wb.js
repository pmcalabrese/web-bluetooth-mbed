let device = null;
let Characteristics = [];

function connect() {
  navigator.bluetooth.requestDevice({ filters: [{ name: ['LED'] }], optionalServices: [0xA000, 0xB000] })
    .then(device => {
      device.addEventListener('gattserverdisconnected', onDisconnected);
      return device.gatt.connect()
    })
    // .then(server => server.getPrimaryService(0xA000))
    .then(server => server.getPrimaryServices())
    // .then(service => service.getCharacteristic(0xA001))
    .then(services => {
      console.log('Getting Characteristics...');
      let queue = Promise.resolve();
      services.forEach(service => {
        queue = queue.then(_ => service.getCharacteristics().then(characteristics => {
          console.log('> Service: ' + service.uuid);
          characteristics.forEach(characteristic => {
            Characteristics.push(characteristic);            
            console.log('>> Characteristic: ' + characteristic.uuid + ' ' +
              getSupportedProperties(characteristic));
          });
        }));
      });
      // setTimeout(function() {
      //   notifyButton2()
      // }, 1000);
      return queue;
    }).then(_ => {
      notifyButton2();
    });
}

function onDisconnected() {
  console.log("device disconnected");
}

function changeState(led_status) {
  var led_status_array = new Uint8Array([led_status]);
  Characteristics[1].writeValue(led_status_array); // Characteristics[1] is the LED which you can write.
}

function readValue() {
  let v = Characteristics[0].readValue().then(value => {
    let v = value.getUint8(0);
    console.log("value", !v);
  })
  .catch(error => {
    console.log('readValue ERROR: ' + error);
  });;
}

function notifyButton2() {
  Characteristics[0].startNotifications().then(_ => {
      console.log('> Notifications started');
      Characteristics[0].addEventListener('characteristicvaluechanged', handleNotificationsButton2);
  }).catch(error => {
    log('Argh! ' + error);
  });
}

function handleNotificationsButton2(event) {
  let value = event.target.value;
  console.log("button2 pressed", !!value.getUint8(0));
}

// utils

function getSupportedProperties(characteristic) {
  let supportedProperties = [];
  for (const p in characteristic.properties) {
    if (characteristic.properties[p] === true) {
      supportedProperties.push(p.toUpperCase());
    }
  }
  return '[' + supportedProperties.join(', ') + ']';
}