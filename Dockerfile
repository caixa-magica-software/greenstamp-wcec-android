# getting base image
FROM ocaml/opam:ubuntu-ocaml-4.13

# installing dependencies 
RUN sudo apt-get update && sudo apt-get install -y openjdk-18-jdk android-sdk google-android-platform-31-installer android-sdk-platform-tools lp-solve

# installing wcec analyser
COPY . wcec

RUN eval $(opam env) && opam install ./wcec

# dune exec wcec /home/ferramenta/apks/facebook_lite.apk