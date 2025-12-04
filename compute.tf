# Declara o provedor cloud que sera usado e sua regiao
provider "aws" {
    region = "us-east-2"
}

# Declara o tipo de dados que serao usados, nesse caso vai ser a instancia EC2 com servidor Ubuntu
data "aws_ami" "ubuntu" {
    most_recent = true # Busca a mais recente

    

    filter {
        name = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
    }

    owners = ["099720109477"] # ID da distribuidora oficial das imagens Ubunto na AWS
}

# Declara o recurso que sera criado, nesse caso uma instancia EC2 com o AMI do Ubuntu
resource "aws_instance" "aws_server" {
    ami = data.aws_ami.ubuntu.id
    instance_type = "t3.micro"

    tags = {
        Name = "AWS Project Instance"
    }
}
