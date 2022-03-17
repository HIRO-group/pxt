# Microsoft PXT adapted for ROS

## Initial setup
First, make sure you have Node.js installed (min version 8).
```
mkdir makecode && cd makecode
git clone <this repo>
mv <this repo> pxt # this renaming step simplifies some later steps
cd pxt
npm install
npm install roslib
npm run build
npm install -g pxt
```

## Linking against this PXT (one-time setup)
To run other PXT apps (like Microbit) with this version of PXT:
1. Clone the app you want to run into the `makecode` directory you created above. 
2. Link and build the dependent packages:
   ```
   cd <other PXT app>
   npm install
   npm link ../pxt
   ```

## Dev setup
After you've followed the above steps once, you can run `gulp watch` in the `pxt` directory in a new terminal; leave it running while you make edits to the code as it will automatically rebuild any files that you change. This step is not required if you're not editing this package.

## Running PXT apps
After you've followed the setup steps open a new terminal and run:
```
roslaunch rosbridge_server rosbridge_websocket.launch
```
Finally, switch to the directory of your pxt app (e.g. `pxt-microbit`) and run `pxt serve` (or `pxt serve --rebundle` to reduce rebuilding).
