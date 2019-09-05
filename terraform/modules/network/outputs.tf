output "ecs_vpc" {
  value = aws_vpc.main.id
}

output "ecs_vpc_cidr" {
  value = aws_vpc.main.cidr_block
}

output "ecs_public_subnet" {
  value = aws_subnet.public.*.id
}

output "ecs_private_subnet" {
  value = aws_subnet.private.*.id
}