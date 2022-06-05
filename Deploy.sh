#!/bin/sh

checkLocalServerHealth() {
  url="localhost:$1/health"
  while :
  do
    status=$(curl -s $url)

    if [ "$status" != "" ]; then
      printf ">> now local:$1 server is running\n"
      break
    fi

    sleep 1
  done
}

# spring-main >> down
sudo sed -i 's/server localhost:8080/#server localhost:8080/g' /etc/nginx/nginx.                                                                                                                                                    conf
sudo nginx -s reload

# main server stop
sudo docker stop "spring-main"
sudo docker rmi "seaworld0125/hoppy-be:latest"

# main server rerun with latest image
sudo docker run -d --name spring-main --rm -p 8080:8080 seaworld0125/hoppy-be:la                                                                                                                                                    test

# check local server health
checkLocalServerHealth 8080

# spring-main >> up
sudo sed -i 's/#server localhost:8080/server localhost:8080/g' /etc/nginx/nginx.                                                                                                                                                    conf

# spring-sub >> down
sudo sed -i 's/server localhost:8081/#server localhost:8081/g' /etc/nginx/nginx.                                                                                                                                                    conf
sudo nginx -s reload

# sub server stop
sudo docker stop "spring-sub"
sudo docker rmi seaworld0125/hoppy-be:sub

# copy image
sudo docker image tag seaworld0125/hoppy-be:latest seaworld0125/hoppy-be:sub

# backup server rerun
sudo docker run -d --name spring-sub --rm -p 8081:8080 seaworld0125/hoppy-be:sub

# check local server health
checkLocalServerHealth 8081

# spring-sub >> up
sudo sed -i 's/#server localhost:8081/server localhost:8081/g' /etc/nginx/nginx.                                                                                                                                                    conf
sudo nginx -s reload
