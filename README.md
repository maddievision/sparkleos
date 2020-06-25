# sparkleOS ✨

right now this is just a simple "hello world" bootloader that goes into protected mode and draws a pixel

![boot screenshot](screenshots/boot_protected.png)

## requirements

nasm - to compile

```
brew install nasm
```

qemu - to emulate

```
brew install qemu
```

## compile

```
make
```

## run on qemu

```
make run
```

## make a bootable usb disk

TBD using fdisk/dd

# what to dooooo next

* [x] protected mode
* [x] draw a pixel
* [ ] draw sparkles
* [ ] long mode
* [ ] kernel
* …
