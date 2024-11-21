#Generamos 2 vm con los siguientes nombres vmAMN y vmDesarrollo
#Configuramos el archivo vagrantfile cambiando el nombre de la vm y su ip
#Para la vmAMN utilizaremos 192.168.56.8 y para vmDesarrollo 192.168.56.9

#Generar clave en la vm AMN
ssh-keygen

#Leer la clave publica
cat $HOME/.ssh/*.pub

#Pegar la clave en el host de la vm Desarrollo
vim .ssh/authorized_keys

#Me conecto desde la vm AMN a Desarrollo para probar
ssh vagrant@192.168.59.9

#Clono el repositorio de ansible en la vm AMN
git clone https://github.com/upszot/UTN-FRA_SO_Ansible.git

#Editamos el archivo inventory
vim UTN-FRA_SO_Ansible/ejemplo_02/inventory
[desarrollo]
192.168.56.9

#Modificamos el playbook para que se actualice e insatale apache
vim UTN-FRA_SO_Ansible/ejemplo_02/playbook.yml

---
- hosts:
    - all
  tasks:
    - name: "Set WEB_SERVICE dependiendo de la distro"
      set_fact:
        WEB_SERVICE: "{% if   ansible_facts['os_family']  == 'Debian' %}apache2
                      {% elif ansible_facts['os_family'] == 'RedHat'  %}httpd
                      {% endif %}"

    - name: "Muestro nombre del servicio:"
      debug:
        msg: "nombre: {{ WEB_SERVICE }}"

    - name: "Run the equivalent of 'apt update' as a separate step"
      become: yes
      ansible.builtin.apt:
        update_cache: yes
      when: ansible_facts['os_family'] == "Debian"

    - name: "Instalando apache "
      become: yes
      package:
        name: "{{ item }}"
        state: present
      with_items:
        - "{{ WEB_SERVICE }}"
#Nos dirijimos
cd UTN-FRA_SO_Ansible/ejemplo_02

#Ejecutamos
ansible-playbook -i inventory playbook.yml

#Nos dirijimos a la vm Desarrollo y verificamos si apache fue instalado
sudo apt list --installed |grep apache
