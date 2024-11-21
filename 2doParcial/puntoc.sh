#Crear la carpeta docker2Parcial en el $HOME
mkdir docker2Parcoal 

#Crear la carpeta appHomeBanking
mkdir appHomeBanking

#Crear los archivos index.html y contacto.html
cat > index.html
cat > contacto.html

#Creamos el archivo dockerfile en docker2Parcial y agregamos lo siguiente
vim dockerfile
FROM nginx
COPY appHomeBanking /usr/share/nginx/html

#Ingresamos a la cuenta 
docker login -u usuario
ingresamos la contraseña del access token.
#Contruimos la imagen
docker build -t rodrigo2142/2parcial-ayso:v1.0 .

#Vemos si la image fue creada
docker image list

#Subimos la imagen a docker hub:
docker push rodrigo2142/2parcial-ayso:v1.0

#Desplegamos la aplicación
docker run -d -p 8080:80 rodrigo2142/2parcial-ayso:v1.0

#Comprabamos si corre
docker container ls

#Paramos el container
docker stop 2dab2ce0f109
