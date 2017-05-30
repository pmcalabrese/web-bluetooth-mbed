<wb-button>

    <div class="column"> 
      <div class="box">
        <pre>{ JSON.stringify(opts) }</pre>
        <h2 class="subtitle is-4">LED2 (read and write)</h2>
        <i class="big-icon { LED2State === null ? 'NC' : ( LED2State == false ? 'ion-ios-lightbulb' : 'ion-ios-lightbulb-outline' ) }"></i><br>
        <button class="button" disabled="{ !connected }" data-state="1" onclick="{ changeLED2State }">Turn LED2 off</button>
        <button class="button" disabled="{ !connected }" data-state="0" onclick="{ changeLED2State }">Turn LED2 on</button>
      </div>
    </div>

  <style>
    :scope { display: block }
    i.big-icon { font-size: 24px; }
    /** other tag specific styles **/
  </style>

  <script>
    this.LED2State = null;
    this.characteristic = null;
    this.connected = false;
      
    this.on('updated', () => {
      console.log("UPDATED: this.opts", this.opts);
    });

    this.changeLED2State = (e) => {
      let led_status = parseInt(e.target.dataset.state, 10);
      let led_status_array = new Uint8Array([led_status]);
      this.opts.characteristic.writeValue(led_status_array)
      .then(value => {
        this.readLED2();
      }); // this.opts.characteristic is the LED which you can write.
    }

    this.readLED2 = () => {
      this.opts.characteristic.readValue().then(value => {
        this.LED2State = value.getUint8(0);
        this.update();
      });
    }
  </script>

</wb-button>