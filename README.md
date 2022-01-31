# Song-Noise-Recorder

Flutter App that is able to play an .mp3 song (local asset) and records the noise levels(in db) of the song
and using mqtt sends the data to a Python desktop app which draws a chart/graph with the results.

## Schematics 
 - Diagram of MQTT Protocol communication
  ![MQTT_Diagram](https://user-images.githubusercontent.com/61873468/116417900-5a3b2480-a844-11eb-996b-d492e5055da1.png)


## Presentation:
https://user-images.githubusercontent.com/61873468/116418088-7d65d400-a844-11eb-8c85-7cf2c76d7e66.mp4



## Prerequisites:
- Android Studio with the latest Flutter SDK
- Python IDE (I'm using PyCharm)
- A physical device (mobile phone)

## Setup and Build
1. install the python *paho-mqtt* library using the command **pip install paho-mqtt**
2. install the python *matplotlib* library using the command **pip install -U matplotlib**
3. the flutter dependencies & permissions are already present in the *pubspec.yaml/AndroidManifest.xml* files and are installed using 
the command **flutter pub get**
4. mqtt uses a public free broker provided by EMQ X which is based on MQTT IoT cloud platform, so you
don't need to setup anything here
5. enable developer options and USB debugging on your physical device

## Run
1. connect a physical device to your computer through USB
2. start the Python mqtt listener
3. select your device in Android Studio and run the app
4. you are done!
