resource "aws_instance" "web" {
  count = 3

  ami           = var.ami_id
  instance_type = var.instance_type

  key_name = "terraform-key"

  subnet_id = element(
    [
      aws_subnet.public1.id,
      aws_subnet.public2.id
    ],
    count.index
  )

  vpc_security_group_ids = [
    aws_security_group.web_sg.id
  ]

  tags = {
    Name = "web-server-${count.index + 1}"
  }
}
