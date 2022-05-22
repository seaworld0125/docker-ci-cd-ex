# spring-main >> down
sudo sed -i 's/localhost:8080/localhost:8080 down/g' /etc/nginx/nginx.conf
sudo systemctl reload nginx

# main server stop
sudo docker stop "spring-main"
sudo docker rmi "seaworld0125/hoppy-be:latest"

# main server rerun with latest image
sudo docker run -d --name spring-main --rm -p 8080:8080 seaworld0125/hoppy-be:latest

# check main server status
until [ "$( sudo docker container inspect -f '{{.State.Running}}' spring-main )" == "true" ]
do
    :
done

# spring-main >> up
sudo sed -i 's/localhost:8080 down/localhost:8080/g' /etc/nginx/nginx.conf
sudo systemctl reload nginx

sleep 5

# spring-sub >> down
sudo sed -i 's/localhost:8081/localhost:8081 down/g' /etc/nginx/nginx.conf
sudo systemctl reload nginx

# sub server stop
sudo docker stop "spring-sub"
sudo docker rmi seaworld0125/hoppy-be:sub

# copy image
sudo docker image tag seaworld0125/hoppy-be:latest seaworld0125/hoppy-be:sub

# backup server rerun
sudo docker run -d --name spring-sub --rm -p 8081:8080 seaworld0125/hoppy-be:sub

# spring-sub >> up
sudo sed -i 's/localhost:8081 down/localhost:8081/g' /etc/nginx/nginx.conf
sudo systemctl reload nginx
