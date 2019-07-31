#! /bin/bash

baseDir=$(pwd | sed s'#/scripts##')

get_magento_public_ip() {
   local ip

   ip=$(grep magento_public_ip -A1 terraform.tfstate | \
        grep value | cut -d: -f2       | \
        sed -e s'/"//g' -r -e s'/,//g' -e s'/[[:space:]]+//g')

   if [ -z "$ip" ]; then
      echo "Magento public IP not found"
      exit 1
   fi

   if ! echo "$ip" | grep -Eq '^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$'; then
      echo "Format IP unknown: $ip"
      exit 1
   fi

   echo "$ip"
}

fileTfState='/var/lib/jenkins/proyecto_final/terraform.tfstate'

# Comprobamos si el fichero terraform.tfstate existe
if [ ! -s "$fileTfState" ]; then
   echo "File \"$fileTfState\" not found"
   exit 1
fi

# Copiamos el fichero terraform.tfstate
cp -af "$fileTfState" .

[ $? -ne 0 ] && exit 1

# Obtenemos la ip publica asignada a la maquina de magento
magentoIp=$(get_magento_public_ip)

# Enviamos los ficheros
rsync -va --stats -e 'ssh -i ~/.ssh/aws_id_rsa' ${baseDir}/data ubuntu@$magentoIp:/tmp/

[ $? -ne 0 ] && exit 1

# Movemos los ficheros a la ruta que le corresponde en la maquina destino
ssh -i ~/.ssh/aws_id_rsa ubuntu@$magentoIp "sudo rsync -va --stats /tmp/data/ /var/www/magento/"

[ $? -ne 0 ] && exit 1

# Reestablecemos permisos
ssh -i ~/.ssh/aws_id_rsa ubuntu@$magentoIp "sudo chown -R www-data. /var/www/magento/app/etc"

[ $? -ne 0 ] && exit 1

exit 0
