# [hymnis/gitea](https://hub.docker.com/r/hymnis/gitea)
Git with a cup of tea, painless self-hosted git service


THIS IS NOT AN OFFICIAL IMAGE FOR GITEA. You can find the official image at [gitea/gitea](https://hub.docker.com/r/gitea/gitea).


This image is based on the [lsiobase/alpine](https://hub.docker.com/r/lsiobase/alpine/) image, which gives some extra functionality. It makes it possible to specify UID and GID for example and have files and folders in volumes owned by a specific user/group.

## Volumes
- **/data**: <path to data> - this is the root data dir where git repositories, gitea configs and ssh keys are stored

## Environment variables
- **PGID**: <yourUID> - specify the GID to use for your container
- **PUID**: <yourGID> - specify the UID to use for your container
- **TZ**: <yourtimezone> - specify your TimeZone e.g. Europe/London

## Ports:
- 3000:3000 - will map the container's web port, 3000 to port 3000 on the host
- 22:22 - will map the containers ssh port, 22 to port 22 on the host

## Usage
Web interface is at `<your ip>:3000` , set up basic configuration (database, paths etc.) and you are good to go.

