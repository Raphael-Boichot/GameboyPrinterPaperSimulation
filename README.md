# Gameboy Printer Paper Simulation V1

* Creation Date: 2020-08-23
* Author: *Raphaël BOICHOT*
* Curator: Brian Khuu

Author of this script is *Raphaël BOICHOT* and was posted here with his permission.

Game boy printer emulator with e-paper feature (CrapPrinter)
Code runs very fast with Matlab, slowly with Octave.

This is a companion project with https://github.com/mofosyne/arduino-gameboy-printer-emulator

The purpose of this octave/matlab script is to do an accurate simulation of an
 output of a gameboy printer and the effect of the thermal printer head on the
 gameboy printer roll. This is not the same as a typical receipt printer as you
 will see in the historical writeup below.

## Simulation of the e-paper output:

<img src="./images/2020-08-23/Game_Boy_Printer_e-paper_1.png" width="40%" height="40%" alt="epaper examples">
<img src="./images/2020-08-23/Game_Boy_Printer_e-paper_2.png" width="40%" height="40%" alt="epaper examples">

## Comparison to pixel perfect output:

![](./images/2020-08-23/Game_Boy_Pixel_perfect_1.png)
![](./images/2020-08-23/Game_Boy_Pixel_perfect_2.png)


--------------------------------------------------------------------------------

# Telegram Gameboy Camera Chatroom

Got telegram instant messaging and have some questions or need any advice, or just want to share? Invite link below:

https://t.me/gameboycamera


--------------------------------------------------------------------------------

# Two ways of using the emulator :

- Copy paste game boy serial data obtained from https://github.com/mofosyne/arduino-gameboy-printer-emulator into Entry_file.txt
- Open Octave/Matlab code "Main_Decoder.m"
- Choose some options
- Run and wait
- Enjoy your images


--------------------------------------------------------------------------------

# Octave Screenshots (As of 2020-08-23)

These are the latest as of 2020-08-23 screen shot

<img src="./images/2020-08-23/octaveBurntPixelPlot.png" width="50%" height="50%" alt="Octave Burnt Pixel Plot">

<img src="./images/2020-08-23/octaveSimPixelDithering.png" width="50%" height="50%" alt="Octave Pixel Dithering">

<img src="./images/2020-08-23/octaveSimVsReal.png" width="50%" height="50%" alt="Octave Simulated Vs Real">

<img src="./images/2020-08-23/octaveSimVsRealZoomed.png" width="50%" height="50%" alt="Octave Simulated Vs Real Zoomed">


--------------------------------------------------------------------------------

# Historical background (As of 2020-08-16)

This conversation occurred in Gameboy Camera Club in discord, contact us for an invite link.

During discussion between *Raphaël BOICHOT* and *maxs - thatguywithagameboycamera*
Raphaël BOICHOT got an idea to simulate the paper output of the gameboy printer.

*herr_zatacke (@herr_gack)* and *Björn (@gameboycameramaniac)* and *crizzlycruz (@23kpixels)* was also in the
chatroom contributing to the discussion of this effort.

> Raphaël BOICHOT
> It gives me an idea : it should be possible to make an "after converter" that outputs images having the same soft aspect that printed paper, I mean the tone, noise, granularity and aliasing due to the printer head. Could somebody send me when possible a very high resolution scan of a printed image from GB camera with a real Game Boy printer, so that I can see what to do ? The idea is to make a real fake printed image.

> R.A.Helllord
> If anyone wants it: https://drive.google.com/file/d/1JRHAElErzPu5oDeHRIkm9hTtXbVukhd9/view?usp=sharing 276MB after compressing it as png, I'll be seeing if I can't get a sharper scan, though

> Raphaël BOICHOT
> It's enough information to try something now, Thanks.

With R.A.Helllord high resolution scan of a real gameboy printer output on good quality paper,
Raphaël BOICHOT obtained a zoomed in sample of the output as ground reference.

![](./images/2020-08-17/RAHelllord_real1.png)

![](./images/2020-08-17/RAHelllord_real2.png)

He also compared with a typical cash receipt

![](./images/2020-08-17/cashTicketExample.png)

From here, Raphaël BOICHOT started work on this project. From the sample of a real printer output, he did a simulation of a single speckle.

![](./images/2020-08-17/octaveSpeckleSim.png)

This allowed him to generate this dot ![](./images/2020-08-17/dot_small.png) and then starting with an original perfect rendering of a gameboy printer output... he carefully crappified it to match the original output in reality.

### Original Image

![](./images/2020-08-17/originalImage.png)

### Attempt 1: First Attempt

![](./images/2020-08-17/attempt1.png)

### Attempt 2: Less Error

* ![](./images/2020-08-17/attempt2_lesserror.png)

### Attempt 3: Less Pixel Masking

* ![](./images/2020-08-17/attempt3_lesspixelmask.png)

### Attempt 4: Hard To Be Crap Like Reality

> It hard to be crap like reality ~ Raphaël BOICHOT

* ![](./images/2020-08-17/attempt4_hardToBeCrapLikeReality.png)

### Attempt 5: Link

* ![](./images/2020-08-17/attempt5_link.png)

### Attempt 6: Squid

* ![](./images/2020-08-17/attempt6_squid.png)

# Gameboy Printer Paper Simulation V2

By Raphaël BOICHOT, 2020-09-10. 
After considering many comparisons between the code V1 and real prints obtained with a recently bought Pocket Printer, I was still not satisfied by the rendering. The difficulty is that the printer add noise to the image at diffrent length scales, what is particularly difficult to render with a fast code. So my new idea was to sample a collection of representative pixels of the different grayscales on a good quality images of isolated pixels printed with my printer.

Typically, there is no image available to print that presents perfectly isolated pixels. My idea was to create a test case with my brand new SD printer :

https://github.com/Raphael-Boichot/The-Arduino-SD-Game-Boy-Printer

So I created this test image :
* ![](./images/2020-09-10/Image_test.png)

Then I scanned a print of this image :
* ![](./images/2020-09-10/Image_test_printed.png)

And I sampled a collection of 50 pixels of each level of grayscale : 
* ![](./images/2020-09-10/Pixel_sample_3600dpi.png)

