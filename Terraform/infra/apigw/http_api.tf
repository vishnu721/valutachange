resource "aws_apigatewayv2_api" "example-api" {
  name          = "example-http-api"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_route" "example" {
  api_id    = aws_apigatewayv2_api.example-api.id
  route_key = "GET /getInfo"
  target    = "integrations/${aws_apigatewayv2_integration.example-api-int.id}"
}

resource "aws_apigatewayv2_integration" "example-api-int" {
  api_id           = aws_apigatewayv2_api.example-api.id
  #credentials_arn  = aws_iam_role.example.arn
  description      = "Example with a load balancer"
  integration_type = "HTTP_PROXY"
  integration_uri  = "arn:aws:elasticloadbalancing:us-east-1:372183352824:listener/app/demo/d548fb9cf15a0107/752b2fae17f017e1"
  #aws_lb_listener.example.arn #ARN of the Load balancer

  integration_method = "ANY"
  connection_type    = "VPC_LINK"
  connection_id      = aws_apigatewayv2_vpc_link.example.id

  tls_config {
    server_name_to_verify = "example.com"
  }

  request_parameters = {
    "append:header.authforintegration" = "$context.authorizer.authorizerResponse"
    "overwrite:path"                   = "staticValueForIntegration"
  }

  response_parameters {
    status_code = 403
    mappings = {
      "append:header.auth" = "$context.authorizer.authorizerResponse"
    }
  }

  response_parameters {
    status_code = 200
    mappings = {
      "overwrite:statuscode" = "204"
    }
  }
}

resource "aws_apigatewayv2_stage" "example" {
  api_id = aws_apigatewayv2_api.example-api.id
  name   = "default-stage"
  auto_deploy = true
}