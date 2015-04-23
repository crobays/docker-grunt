## Run Grunt in a container on top of [phusion/baseimage](https://github.com/phusion/baseimage-docker)

	docker build \
		 --name crobays/grunt \
		 .

	docker run \
		-v ./:/project \
		crobays/grunt
