### 
# Resources
###
Docker intro video
https://www.youtube.com/watch?v=YFl2mCHdv24



###
# Tips & Tricks
###
All directories with perl scripts (files ending in .pl) need a .htaccess file with the following:
	DirectoryIndex index.pl index.html
	Options +ExecCGI
	AddHandler cgi-script cgi pl

Variables enclosed in {} are placeholders and will need to be updated to real values
Example:
'docker build -t {$DOCKER_NAME} .' => 'docker build -t testdocker .'

Perl scripts (files ending in .pl) need to be executable which can be done with the command
'chmod 775 {$FILENAME}'


###
# Running a docker 
###
1. Open terminal and change directory to where Dockerfile file and code is (same directory as this README)

1-1. Run command to login to drocker via command line (optional)
'docker login'

2. Run command to build the docker image, if no errors then continue (this step may take a while depending on internet speeds)
'docker build -t {$DOCKER_NAME} .'

3. Run command to run the docker image in container, or run 3-1 to mount local files
'docker run -p 80:80 {$DOCKER_NAME}'

3-1. Run command to run the docker image in container with shared volume (can edit files in html directory and then refresh docker pages to see updates)
'docker run -p 80:80 -v /Path/On/Local/Machine/To/Docker/html_directory/:/var/www/html/ {$DOCKER_NAME}'

4. Open browser and enter the URL to view 
'http://localhost:80' 





###
# Debugging a running docker
###
1. Open terminal and find container name by running the command
'docker container ls'

2. Use name from last column of table output with column header 'NAMES'

3. Run command to connect into running docker using the name from previous step
'docker exec -it {$DOCKER_NAME} /bin/bash'

4. You now have root access in the container and can diagnose

4-1. To view live http logs run the command
'tail -f /var/log/httpd/error_log'