<app>
  <!-- layout -->
  <div class="columns">
    <div class="column">
      <button class="button" onclick="{ connect }"><span class="icon"><i class="ion-bluetooth"></i></span>Connect ({ connected ? 'connected' : 'not connected'  })</button>
      <hr>
      <pre class="code">
        { this.debug_text }
      </pre>
    </div>
  </div>
  <div class="columns">
    <div class="column"> 
      <pre>{ JSON.stringify(characteristic) }</pre>
      <div class="box">
        <h2 class="subtitle is-4">LED2 (read and write)</h2>
        <i class="big-icon { LED2State === null ? 'NC' : ( LED2State == false ? 'ion-ios-lightbulb' : 'ion-ios-lightbulb-outline' ) }"></i><br>
        <button class="button" disabled="{ !this.connected }" data-state="1" onclick="{ changeLED2State }">Turn LED2 off</button>
        <button class="button" disabled="{ !this.connected }" data-state="0" onclick="{ changeLED2State }">Turn LED2 on</button>
      </div>
    </div>
    <div class="column">     
      <div class="box">
        <h2 class="subtitle is-4">BUTTON1 (read and notify)</h2>
        <i class="big-icon { button_value === null ? 'NC' : ( button_value == true ? 'ion-android-radio-button-on' : 'ion-ios-circle-outline' ) }"></i><br>
        <button class="button" disabled="{ !this.connected }" onclick="{ readButton2Value }">Read value</button>
      </div>
    </div>
  </div>

  <style>
    :scope { display: block }
    i.big-icon { font-size: 24px; }
    /** other tag specific styles **/
  </style>

  <script>
    let device = null;
    let Characteristics = [];
    this.connected = false;
    this.LED2State = null;
    this.button_value = null;
    this.debug_text = "";
    this.characteristics = [];

    this.connect = () => {
      navigator.bluetooth.requestDevice({ filters: [{ name: ['LED'] }], optionalServices: [0xA000, 0xB000] })
        .then(device => {
          device.addEventListener('gattserverdisconnected', this.onDisconnected);
          return device.gatt.connect()
        })
        // .then(server => server.getPrimaryService(0xA000))
        .then(server => server.getPrimaryServices())
        // .then(service => service.getCharacteristic(0xA001))
        .then(services => {
          this.log('Getting Characteristics...' + this.connected);
          this.connected = true;
          this.update();
          let queue = Promise.resolve();
          services.forEach(service => {
            queue = queue.then(_ => service.getCharacteristics().then(characteristics => {
              this.log('> Service: ' + service.uuid);
              characteristics.forEach(characteristic => {
                Characteristics.push(characteristic);
                this.characteristics = Characteristics;
                this.update();
                this.log('>> Characteristic: ' + characteristic.uuid + ' ' +
                  getSupportedProperties(characteristic));
              });
            }));
          });
          return queue;
        }).then(_ => {
          this.readLED2();
          this.readButton2Value();
          this.notifyButton2();
        });
    }

    this.log = (text) => {
      this.debug_text += text + '\n';
      this.update();
    }

    this.onDisconnected = () => {
      this.connected = false;
      this.update();
      this.log("> Device disconnected");
    }

    this.readLED2 = () => {
      Characteristics[1].readValue().then(value => {
        let v = value.getUint8(0);
        this.LED2State = v;
        this.update();
      });
    }

    this.changeLED2State = (e) => {
      let led_status = parseInt(e.target.dataset.state, 10);
      var led_status_array = new Uint8Array([led_status]);
      Characteristics[1].writeValue(led_status_array)
      .then(value => {
        this.readLED2();
      }); // Characteristics[1] is the LED which you can write.
    }

    this.readButton2Value = () => {
      let v = Characteristics[0].readValue().then(value => {
        let v = value.getUint8(0);
        this.button_value = v;
        this.update();
      })
      .catch(error => {
        this.log('readButton2Value ERROR: ' + error);
      });;
    }

    this.notifyButton2 = () => {
      Characteristics[0].startNotifications().then(_ => {
          this.log('> Notifications started');
          Characteristics[0].addEventListener('characteristicvaluechanged', this.handleNotificationsButton2);
      }).catch(error => {
        this.log('notifyButton2 ERROR: ' + error);
      });
    }

    this.handleNotificationsButton2 = (event) => {
      let value = event.target.value;
      this.button_value = !!value.getUint8(0);
      this.update();
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
  </script>

</app>