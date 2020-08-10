docker build -f savapage.Dockerfile --tag savapage-ubuntu18.04 .
docker run -p 8631:8631 -p 8632:8632 --volume $(pwd):/workspace -it savapage-ubuntu18.04:latest