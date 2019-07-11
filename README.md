# Description
This image provides Ansible ARA 0.16.5 uwsgi socket.

# Build
docker build -t ara:0.16.5 .

# Run
docker run --name ara_web -e MYSQL_HOST=your_mysql_host -p 8082:8082 -d ara:0.16.5
