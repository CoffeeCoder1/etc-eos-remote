# ETC Eos Remote

A third-party remote control app for ETC Eos family lighting consoles, designed to assist in focusing lights.

> [!WARNING]  
> Development on this has stopped pretty much completely, since I've been running into a ton of issues with Godot (it's not really designed to make apps like this). I'm actively working on reimplementing it using Qt, so stay tuned for more updates!
> 
> UPDATE - This has now been superseded by the [Universal Focus Remote](https://github.com/CoffeeCoder1/universal-focus-remote) project.

<img width="752" alt="Screenshot 2025-01-29 at 09 07 18" src="https://github.com/user-attachments/assets/05ecd14e-3802-4ec6-a879-113ae9a6de28" />

## Installation

Download the [latest release](https://github.com/CoffeeCoder1/etc-eos-remote/releases/latest).

## Usage

Open the `App Settings` menu with the button in the top right, and enter the IP address of your board. You can find this under `Setup` -> `Device` -> `Network`. By default, the app uses the third-party OSC port, which should be enabled by default. If the app can not connect, make sure that `Third Party OSC` is enabled on the same page.

## Support

If you run into any issues, please submit an issue on the [issues tab](https://github.com/CoffeeCoder1/etc-eos-remote/issues) on this repo. This software is still in pretty early development, and it hasn't been very thoroughly tested, so issues are very helpful in figuring out what I still need to fix.

## Protocol

This app controls the console over OSC, as is documented in the [Eos Family User Manual](https://www.etcconnect.com/WebDocs/Controls/EosFamilyOnlineHelp/en-us/Default.htm#32_Show_Control/08_Open_Sound_Control_(OSC)/Using_OSC.htm).
