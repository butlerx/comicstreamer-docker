FROM debian
MAINTAINER TuRzAm

ENV PORT=32500 WEBROOT=""
RUN apt-get update && \ 
    apt-get install python python-pip python-dev git libjpeg-dev -y && \
    adduser \ 
	--disabled-login \ 
	--shell /bin/bash \ 
	--gecos "" \ 
	comicstreamer

# Copy & rights to folders
COPY run.sh /home/comicstreamer/run.sh

RUN chmod 777 /home/comicstreamer/run.sh && \
    mkdir /comics && chown comicstreamer /comics &&\
    git clone https://github.com/davide-romanini/ComicStreamer.git /home/comicstreamer/ComicStreamer

WORKDIR /home/comicstreamer/ComicStreamer
RUN pip install -r requirements.txt && \
    chown comicstreamer -R .
USER comicstreamer 
RUN paver libunrar
# Expose default port : 32500
EXPOSE ${PORT}
VOLUME "/comics" 
ENTRYPOINT ["/home/comicstreamer/run.sh"]
