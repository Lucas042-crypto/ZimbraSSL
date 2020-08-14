# ZimbraSSL

Script tem como sua principal função incluir e renovar o certificado SSL Letencrypt do zimbra automaticamente.

Faça o download do repositório letsencrypt no caminho

sudo git clone https://github.com/letsencrypt/letsencrypt /usr/local/sbin/letsencrypt

Basta colocar no crontab do linux ou executar da seguinte forma:

Crontab

00 00 * * * /usr/local/sbin/renew.sh dominio

Manual

/usr/local/sbin/renew.sh dominio

Ele busca direto do site:

https://www.identrust.com/dst-root-ca-x3

A chave root CA e ja faz tudo automatizado. Foi testado e homologado em 3 servidores zimbra diferentes.

Espero que gostem!

