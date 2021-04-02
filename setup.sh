# curl https://raw.githubusercontent.com/ernesto-elsaesser/geounblocker/master/setup.sh > setup.sh
# run as sudo!

extip=$1
intip=$2
logdir=$3

apt install dnsmasq sniproxy

# local-ttl=60
echo "
log-facility=$logdir/dnsmasq.log
domain-needed
no-resolv
no-hosts
address=/#/$extip
listen-address=127.0.0.1
listen-address=$intip" > /etc/dnsmasq.conf

# port dns=53 udp + tcp
service dnsmasq restart

#user daemon
#resolver {
#    mode ipv4_only
echo "
pidfile /var/run/sniproxy.pid

error_log {
    filename $logdir/sniproxy-error.log
    priority debug
}

access_log {
    filename $logdir/sniproxy-access.log
    priority debug
}   
    
listener 443 {
    proto tls
}

listener 80 {
    proto http
}

table {
    .* *
}

resolver {
    nameserver 8.8.8.8
    mode ipv4_first
}
" > /etc/sniproxy.conf

# port http=80 & https=443 tcp
service sniproxy restart
