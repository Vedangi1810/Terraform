resource aws_key_pair my_key{
    key_name = "terra-key-ec2"
    public_key = file("terra-key-ec.pub")
}

resource aws_default_vpc default{

}

resource aws_security_group my_security_group{
    name = "automate-sg"
    description = "This will add TF generated security group"
    vpc_id = aws_default_vpc.default.vpc_id #Interpolation

    # inbound rules
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "SSH open"
    }

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "HTTP open"
    }

    ingress {
            from_port = 8000
            to_port = 8000
            protocol = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
            description = "Notes app open"
    }

    egress {
            from_port = 0
            to_port = 0
            protocol = "-1"
            cidr_blocks = ["0.0.0.0/0"]
            description = "all access open outbound"
    }

    tags = {
        Name = "automate-sg"
    }
}

resource "aws_instance" "my_instance" {
    key_name = aws_key_pair.my_key.key_name
    security_groups = [aws_security_group.my_security_group.name]
    instance_type = "t2.micro"
    ami = "ubuntu_ami_id"

    root_block_device {
        volume_size = 15
        volume_type = "gp3"
    }

    tags = {
        Name = "vd_automate"
    }
}