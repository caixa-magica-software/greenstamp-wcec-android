# getting base image
FROM ocaml/opam:ubuntu-ocaml-4.13

# installing dependencies 
RUN sudo apt-get update && sudo apt-get install -y openjdk-18-jdk android-sdk google-android-platform-33-installer android-sdk-platform-tools lp-solve

# installing wcec analyser
COPY --chown=opam . wcec    

RUN eval $(opam env) && opam install ./wcec

COPY ./script.sh /
USER root 
RUN chmod +x /script.sh
USER opam
# Set the entrypoint to the script with CMD arguments
ENTRYPOINT ["/script.sh"]