# How to use

docker run --privileged \
	-e ANYCONNECT_USER=... \
	-e ANYCONNECT_PASSWORD=... \
	-e ANYCONNECT_SERVER=... \
	-e ANYCCONNECT_PING=... \
	-e ANYCONNECT_OPTIONS="--servercert ..." \
	 morinpa/docker-anyconnect-vpn 
