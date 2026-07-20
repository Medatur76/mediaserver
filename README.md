# MOSL Media Server

This is a C biased web server for hosting various types of downloaded media!

## What is MOSL?

MOSL - Multi Operating System Library  
This is the name I gave the ``sys.h`` and ``sys_defs.S`` files which power the entire program.  
Essentially, there is no standard library in this project at all. Every instruction that requires an external header has been rewritten to compress final executable file size and actually acomplish the Multi in MOSL.  
Beacuse of this custom library I made, if your system is:

- Windows
- Linux
  - x86_64
  - i386
  - aarch64
  - arm

simply install ``GNU GCC`` and run the script file for your system (``.bat`` for windows and ``.sh`` for linux) and an executable for your system will appear in the ``bin`` folder! Thats it!

## Features

- [ ] Single executable
  - Just run the program file for your system/architecture and the program will automatically setup its default state in the current folder!
- [ ] 2FA support
  - By default, the program locks any access to the website behind a 2FA check for security purposes.
  - Easially scanable QR code in the terminal to get your 2FA setup.
  - This is 100% optional. You can go into the configuration file and disable this to open the site to anyone!
  - (Username/password support comming soon!)
- [ ] Custom port
  - By default the program uses port ``8080`` but it can be configured to use any port ``0``-``1024``.
- [ ] Supports multiple forms of media
  - After installation, simply navigate to ``127.0.0.1:8080/..``, and drag and drop all the files you want. Video, audio and image are all supported!
  - For added detail to your files, navigate instead to ``127.0.0.1:8080/..``, and fill out information about the files that will show up when searching for and viewing the file later on!
- [ ] FFmpeg support
  - Should FFmpeg be installed on your machine, the program will automatically format inputted files to the most efficent form for web viewing.
- [X] Customizability
  - By opening the ``web`` folder, you can customize every aspect of the site you see from the website!
