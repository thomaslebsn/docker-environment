#! /bin/bash

# Colors used for status updates
ESC_SEQ="\x1b["
COL_RESET=$ESC_SEQ"39;49;00m"
COL_RED=$ESC_SEQ"31;01m"
COL_GREEN=$ESC_SEQ"32;01m"
COL_YELLOW=$ESC_SEQ"33;01m"
COL_BLUE=$ESC_SEQ"34;01m"
COL_MAGENTA=$ESC_SEQ"35;01m"
COL_CYAN=$ESC_SEQ"36;01m"
BLUE='\033[0;34m'

function init_php_exts(){
    phpenmod zip
    phpenmod mbstring
    phpenmod soap
    phpenmod xdebug
}

function init_a2(){
    cd /etc/apache2/sites-available
    for file in /etc/apache2/sites-available/*
    do
      filename=$(basename "$file")

      if [ "$filename" != "sample.conf.example" ]
      then
          echo $filename
          a2ensite $filename
      fi
    done

    a2dismod php7.1
    a2enmod php7.4
    a2enmod ssl
}

function print_to_screen(){
    echo -e "$COL_GREEN ===== ${1} ===== $COL_RESET \n "
}

function cmd_init_all(){

    print_to_screen "RELOAD BASHRC";
    source ~/.bashrc;

    init_a2;
    init_php_exts;
    cmd_grant_permissions
    cmd_enable_php_fpm

    print_to_screen "STARTING SUPERVISORD";
    cmd_supervisor_init

    print_to_screen "STARTING OPENSSH SERVER";
    cmd_openssh_server_init

    print_to_screen "COPYING SSH-KEYS TO ~/.ssh";
    cmd_cp_existed_ssh_keys_to_ssh_directory

    print_to_screen "STARTING SERVICE APACHE2";
    service apache2 stop;
    service apache2 start;
    service apache2 status;

    print_to_screen "STARTING SERVICE MEMCACHED";
    service memcached start;
    service memcached status;

    print_to_screen "STARTING SERVICE REDIS CACHE";
    redis-server /etc/redis/redis.conf;
    redis-cli flushall;
    print_to_screen "TEST REDIS SERVER BY REDIS-CLI";
    redis-cli PING;

    cd /var/www;
}

function cmd_grant_permissions(){
    print_to_screen "ROLES & PERMISSIONS HANDLER";
#    cd /var/www/ulspmage2;
#    chmod 777 var/ pub/ -R;
#    chmod 775 bin/ -R;
}

function cmd_restart_all_services(){
    print_to_screen "RE-STARTING SERVICE APACHE2";
    service apache2 restart;
    service apache2 status;

    print_to_screen "RE-STARTING SERVICE MEMCACHED";
    service memcached stop;
    service memcached start;
    service memcached status;

    print_to_screen "RE-STARTING SERVICE REDIS CACHE";
    service redis-server stop;
    redis-server /etc/redis/redis.conf;
    redis-cli flushall;
    print_to_screen "RE-TEST REDIS SERVER BY REDIS-CLI";
    redis-cli PING;
}

function cmd_set_crontabs() {
     if ! crontab -l | grep -a "$1";
     then
        crontab -l | { cat; echo "$1"; } | crontab -
     fi
}

function cmd_supervisor_init() {
    /etc/init.d/supervisor start;
    /etc/init.d/supervisor status;
    supervisorctl status;
}

function cmd_supervisor_restart_all(){
    supervisorctl reread;
    supervisorctl restart all;
}

function cmd_openssh_server_init(){
    service ssh start;
    service ssh status;
}

function cmd_store_git_credentials_globally(){
    print_to_screen "Enter your git credentials for storage (e.g. {remote-url-protocol}://{username}:{password}@{remote-url}):"
    read git_credentials_url
    echo "$git_credentials_url" >> ~/.git-credentials
    git config --global credential.helper 'store --file ~/.git-credentials'
    print_to_screen "Finish storage globally git credentials (just for development environment purpose)"
    git config --global user.name "Thien Le - Docker"
    git config --global user.email "thien.leduc@elinext.com"
    print_to_screen "Finish set globally user name and email that are required time to time in source when interacting with GIT"
}

function cmd_cp_existed_ssh_keys_to_ssh_directory(){
    mkdir -p ~/.ssh
    cp /home/sshkeys/* ~/.ssh
    cat ~/.ssh/insecure_id_rsa.pub >> ~/.ssh/authorized_keys
    chmod 600 ~/.ssh/insecure_id_rsa
    chmod 644 ~/.ssh/insecure_id_rsa.pub ~/.ssh/authorized_keys
}

function cmd_enable_php_fpm(){
    a2enmod proxy_fcgi setenvif
    a2enconf php7.4-fpm
    service apache2 restart
}
