##############################
#ECS
##############################

output "ecs_cluster_name" {
  description = "The name of the opt ct Account Backend ECS cluster."
  value       = aws_ecs_cluster.ecs-cluster.name
}

output "ecs_cluster-arn" {
  description = "The ARN of the opt ct Account Backend ECS cluster."
  value       = aws_ecs_cluster.ecs-cluster.arn
}

output "ecs-td-arn" {
  description = "The ARN of the opt ct Account Backend ECS task definition."
  value       = aws_ecs_task_definition.ecs-td.arn
}

output "ecs-service-arn" {
  description = "The ARN of the opt ct Account Backend ECS Service."
  value       = aws_ecs_service.ecs-service.id
}

output "ecs-service-name" {
  description = "The Name of the opt ct Account Backend ECS Service."
  value       = aws_ecs_service.ecs-service.name
}

output "ecs-sg-arn" {
  description = "The ARN of the opt ct Account Backend ECS Security Group."
  value       = aws_security_group.ecs-sg.arn
}

##############################
#Load Balancer
##############################
output "tg-id" {
    description = "The id of the opt ct Account Backend Target Group"
    value = aws_lb_target_group.tg.id 
}

output "tg-arn" {
    description = "The ARN of the opt ct Account Backend Target Group"
    value = aws_lb_target_group.tg.arn
}

output "lb-id" {
    description = "The id of the opt ct Account Backend Load Balancer"
    value = aws_lb.lb.id
}

output "lb-arn" {
    description = "The ARN of the opt ct Account Backend Load Balancer"
    value = aws_lb.lb.arn
}

output "lb-dns" {
    description = "The DNS of the opt ct Account Backend Load Balancer"
    value = aws_lb.lb.dns_name
}

output "lb-listener-id" {
    description = "The Id of the opt ct Account Backend Load Balancer Listener"
    value = aws_lb_listener.lb-listener.id
}

output "lb-listener-arn" {
    description = "The ARN of the opt ct Account Backend Load Balancer Listener"
    value = aws_lb_listener.lb-listener.arn
}

output "lb-sg-arn" {
  description = "The ARN of the opt ct Account Backend Load Balancer Security Group."
  value       = aws_security_group.lb-sg.arn
}

