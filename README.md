# Docker XML RESUME LIBRARY - 1.5.1

A docker container version of XML Resume Library.

To build the image `DOCKER_BUILDKIT=1 docker build -t resume-1_5_1:latest .`

To run a container instance you should mount the output generated directory and input xml directory
`docker run -v /Users/ewan/dev/resume-1_5_1/generated:/usr/src/resume-1_5_1/generated -v /Users/ewan/dev/resume-1_5_1/test:/usr/src/resume-1_5_1/xml -it resume-1_5_1:latest /bin/sh`

Inside the container to generate you CV you should override the environment variable CV_TITLE with your cv xml filename and one of the scripts
`CV_TITLE=example1 ./run.sh`

* For a complete guide to the XML Resume Library please see the
file doc/index.html file.

* For a short list of the new features of this release, please see
doc/news/index.html.  A complete CVS changelog is available in
doc/changelog/index.html.

* Please see doc/copying/index.html for copying conditions, license, and
disclaimer.
