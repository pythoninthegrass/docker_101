### Docker

* Install from the [Setup](../README.md#setup) section
* Usage
  * Docker
    ```bash
    # show running containers
    docker ps

    # show images
    docker images

    # build docker image and tag
    docker build -t helloworld .    # --no-cache=true

    # run image with interactive tty and remove container after
    docker run -it --rm helloworld

    # override entrypoint
    docker run -it --rm --entrypoint=bash helloworld

    # run image with volume mount and published port (host:container)
    docker run -it --rm -v $(pwd):/app -p 80:5000 helloworld

    # run image in background (detached) with shortened name 'hello'
    docker run -it -d --name hello helloworld

    # exec into container
    docker exec -it helloworld bash

    # stop container
    docker stop hello

    # show all containers
    docker ps -a

    # remove volume
    docker rm -v <container_sha>

    # clean up images
    docker rmi helloworld
    ```
  * Docker Compose
    ```bash
    # clean build (remove `--no-cache` for speed)
    docker-compose build --no-cache --parallel

    # start container
    docker-compose up --remove-orphans -d

    # ssh into container (`exec` is more useful if the entrypoint is running a process/server)
    docker attach hello

    # stop container
    docker-compose stop

    # destroy container and network
    docker-compose down
    ```

#### Debugging
* Watch logs in real-time: `docker-compose logs -tf --tail="50" hello`
* Check exit code
    ```bash
    $ docker-compose ps
    Name                          Command               State    Ports
    ------------------------------------------------------------------------------
    docker_python      python manage.py runserver ...   Exit 0
    ```
