resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.contact.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "arn:aws:execute-api:${var.aws_region}:${var.account_id}:${aws_api_gateway_rest_api.api.id}/*/${aws_api_gateway_method.contact_post.http_method}${aws_api_gateway_resource.contact.path}"
}

#tfsec:ignore:aws-lambda-enable-tracing
resource "aws_lambda_function" "contact" {
  filename      = data.archive_file.dummy_archive.output_path
  function_name = "wagonkered-contact-form"
  role          = aws_iam_role.contact.arn
  handler       = "bin/main"
  runtime       = "go1.x"
  environment {
    variables = {
      RECAPTCHA_SECRET = var.recaptcha_secret
      RECEIVER         = var.receiver_email
      SENDER           = var.sender_email
    }
  }
}

resource "aws_iam_role" "contact" {
  name = "wagonkered-contact-form-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}

resource "aws_iam_policy" "contact_lambda_policy" {
  name = "contact_lambda_policy"
  path = "/"
  policy = jsonencode({
    Statement = [
      {
        Action = [
          "ses:SendRawEmail",
          "ses:SendEmail",
        ]
        Effect   = "Allow"
        Resource = "arn:aws:ses:${var.aws_region}:${var.account_id}:identity/*"
        Sid      = "0"
      },
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
        ]
        Resource = "${aws_cloudwatch_log_group.contact_form_log_group.arn}:*"
        Effect   = "Allow"
        Sid      = "1"
      }
    ]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "contact_lambda_policy_attachment" {
  role       = aws_iam_role.contact.name
  policy_arn = aws_iam_policy.contact_lambda_policy.arn
}


#tfsec:ignore:aws-cloudwatch-log-group-customer-key
resource "aws_cloudwatch_log_group" "contact_form_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.contact.function_name}"
  retention_in_days = 14
}

