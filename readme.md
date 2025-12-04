🚀 Desafio: "The Immutable LAMP Stack" (Infraestrutura Imutável com Backup Automatizado)
Cenário da Startup: A startup "TechNova" precisa lançar uma aplicação interna de gestão (pode ser um WordPress simples ou um app PHP customizado). O CTO exigiu que a infraestrutura seja descartável: se o servidor explodir, devemos ser capaz de subir outro em minutos sem configuração manual. Além disso, os logs de acesso devem ser auditáveis e salvos fora do servidor por questões de compliance.

Seu Objetivo: Criar toda a infraestrutura via código, onde o servidor web se conecta a um banco de dados gerenciado e envia logs automaticamente para um Bucket S3, sem jamais salvar credenciais AWS dentro do servidor.

1. Arquitetura Exigida (O "Ouro" do Projeto)
Você vai utilizar o AWS Free Tier para orquestrar três serviços principais:

EC2 (Compute): Uma instância t2.micro ou t3.micro rodando Amazon Linux 2 ou Ubuntu. Ela será o servidor Web (Apache/Nginx + PHP).

RDS (Database): Uma instância RDS MySQL ou MariaDB (db.t3.micro) para guardar os dados da aplicação. Proibido instalar o banco de dados dentro da EC2.

S3 (Object Storage): Um bucket privado para receber os logs de acesso do servidor web (ex: /var/log/apache2/access.log).

2. Requisitos Técnicos (Onde você prova seu valor)
A. Infraestrutura como Código (Terraform)
Proibido ClickOps: Toda a infraestrutura deve ser criada via Terraform.

Modularização: Não quero um arquivo main.tf gigante com 500 linhas. Separe em módulos (ex: networking, compute, database).

State: O arquivo de estado do Terraform (.tfstate) não deve ser comitado no Git (use .gitignore).

B. Segurança e Redes (Networking)
Esta é a parte onde eu reprovo candidatos. Preste atenção:

Security Groups (SG) Encadeados:

SG do EC2: Deve permitir porta 80 (HTTP) para 0.0.0.0/0.

SG do EC2 (SSH): Deve permitir porta 22 APENAS para o seu IP público atual. (Dica: Use uma variável no Terraform ou um data source http para pegar seu IP automaticamente).

SG do RDS: Deve permitir porta 3306 APENAS vindo do SG do EC2. Não coloque IPs aqui. O banco de dados só deve aceitar conexões vindas do grupo de segurança do servidor web.

IAM Roles (Identity Access Management):

Zero Credenciais Locais: Você NÃO pode rodar aws configure dentro da EC2. Você deve criar uma IAM Role com permissão AmazonS3FullAccess (ou, melhor ainda, uma policy customizada só de PutObject) e anexar essa Role à instância EC2 via Terraform.

C. Automação e Linux (User Data)
O servidor deve nascer pronto. Use o user_data do Terraform para passar um script Shell que:

Atualize o SO (apt update / yum update).

Instale o Apache/Nginx e PHP.

Crie um script simples em /var/www/html/index.php que mostre "Conexão com Banco de Dados: Sucesso/Falha" (testando a conexão com o RDS).

O Desafio Linux: Crie um Cronjob ou um script systemd que, a cada 5 minutos, copie o arquivo de log do Apache para o seu Bucket S3. (O comando será algo como aws s3 cp ..., e deve funcionar sem senha porque você configurou a IAM Role).