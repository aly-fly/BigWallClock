# Big Wall Clock
![.](/Photo/clock_working_rainbow.jpg)

### Story time.
_I was walking through the hardware store with my wife. High up on the wall was a huge, beautiful wooden clock. Like one meter diameter. Price tag was also pretty high. I said "I can make one like this." My brain immediatelly started adding features and making improvements. When the permission was given to kick-off teh project, I was happy!_

## What we need

* Wooden plate
* Mechanism
* Feedback device
* Motor and driver
* Controller
* Clock hands and numbers
* Power supply

### Wooden plate
If you don't have a relative or friend that has a woodworking shop, best next option is a local furniture producer. Or recycle some other furniture with nice looking patterns.

### Mechanism
Clock with 1 meter diameter needs big and heavy clock hands. Standard off-the-shelf driving mechanism is not strong enough, and it also doesn't offer much challenges. 
Having a 3D printer in my workshop and with lots of initiative to learn mechanical design, I downloaded Fusion 360 and started learning. Produced design is not optimal, but works pretty well. For the next iteration (if it ever comes up) one more gear after the motor is needed to increase the torque. Everything is printed from PLA, as it is hard enough so that gears should last quite some time. PETG was an alternative, as it has better dimensional tolerances and better endurance, but for now it was not needed.

![.](/Photo/gears_1.jpg)

### Feedback device
Main idea is that clock adjusts itself to the correct time, and also takes care of the Daylight Savings time changes. For this it is required to know exact position of the clock hands. As an engineer developing the rotary encoders, my first thought was which part from our portfolio would fit. [AksIM-2](https://www.rls.si/eng/aksim-2-off-axis-rotary-absolute-encoder) with 29 mm diameter was a perfect fit. With 17-bit resolution this gives more than 2000 counts between two neighbouring minute marks on the clock face. A bit to much isn't it :) But this can be used to make a very smooth and precise time-keeping. As encoder has RS422 differential output, a linedriver is required to convert signals to 3.3V LVTTL for the processor.

![.](/Photo/encoder.jpg)

### Motor and driver
With very low space available, the only motor that would fit was some thin stepper. Aliexpress delivered again. Two variants were ordered, first one with 90 steps didn't have enough torque, so slightly thicker motor with better precision and better build quality was a good candidate. [0.9 Degree Mini 36mm Round Thin Stepper Motor](https://www.aliexpress.com/item/1005008263498118.html)

![.](/Photo/motor.jpg)

Having a stepper driver at hand from some other project was beneficial. ST-Spin family has some really great devices. [PowerStep01](https://www.st.com/en/motor-drivers/powerstep01.html) chip is way too powerful for what is needed here, but pure sine wave driver with 128-microstepping and quiet voltage mode really makes difference in this project.

![.](/Photo/motor_driver.jpg)

### Controller
The programming work starts here. We need something easy to use, powerful, with lots of peripherals and of course WiFi connectivity. ESP32 series is an easy choice. 
* WiFi is used to get current time from the NTP server
* MQTT client talks to the HomeAssistant
* UART polls data from the encoder
* SPI Sends commands to the motor driver
* ADC reads the temperature sensor of the motor
* RMT peripheral controls the addressable LED strip
* Flash filesystem is used to store system messages for later review

![.](/Photo/controller.jpg)

### Clock hands and numbers
Everything designed in Fusion 360 and printed from PLA or PETG. 

![.](/Photo/printer.jpg)

### LED strip
120 LEDs is a nice number to have one pixel per minute plus one in between. 60 LEDs per meter is a good choice for nice and uniform colors. The chinese guys [delivered again](https://www.aliexpress.com/item/1005006838558445.html).

### Power supply
Such a project can't be battery powered. A standard 24 V, 1 A, wall-plug supply works well. 24 V is for the motor driver. 
- Traco power [TSR 1-2450](https://www.tracopower.com/int/model/tsr-1-2450) powers the ESP32 board and encoder (1A limit).
- Traco power [TSR 3-24150](https://www.tracopower.com/int/series/tsr-3) powers the LED strip (3A limit).


## Everything mounted and tested
![.](/Photo/clock_mechanism.jpg)
![.](/Photo/clock_preview_back.jpg)

### And final step is HA integration
And then the family starts enjoying the new decoration in the house.

![.](/Photo/HA_small.png)



