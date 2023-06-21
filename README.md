# wcec-android


Static analysis (Abstract Interpretation) tool for WCEC android app analysis.


## dependecies:

lp_solve;
dune;
java:
sdkmanager "platform-tools" "platforms;android-31"



## Build and Run

```
cd wcec-android 
```

Build docker image:

```
sudo docker build . -t wcec
```

Run docker image and move inside:

```
sudo docker run -it -v /home/campos/git/greenstamp/apk:/apks --rm wcec /bin/bash
```

Run tester:

```
cd wcec/
dune exec wcec /apks/rtp.apk
```
