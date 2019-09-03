output "ecs_vpc" {
  value = aws_vpc.main.id
}

output "ecs_public_subnet" {
  value = aws_subnet.public.*.id
}

output "ecs_private_subnet" {
  value = aws_subnet.private.*.id
}

output "ec2_network_interface" {
  value = aws_network_interface.ec2_network_interface[0].id
}