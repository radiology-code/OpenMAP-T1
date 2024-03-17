IMAGE_NAME := openmap-t1
build-docker:
	docker build -t $(IMAGE_NAME) .
build-apptainer:build-docker
	# https://apptainer.org/docs/user/main/docker_and_oci.html
	# build from local daemon instead of a registry, must specify tag
	apptainer build --build-arg IMAGE_NAME=$(IMAGE_NAME) $(IMAGE_NAME).sif apptainer.def

