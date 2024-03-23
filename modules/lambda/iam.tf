# Iam role and policy to be created for attaching to lambda

locals {
  create_role = local.create && var.create_function && var.create_role

  log_group_arn_regional =  aws_cloudwatch_log_group.lambda[0].arn
  log_group_name         = aws_cloudwatch_log_group.lambda[0].name
  log_group_arn = aws_cloudwatch_log_group.lambda[0].arn

  role_name   = local.create_role ? coalesce(var.role_name, var.function_name, "*") : null
  policy_name = coalesce(var.policy_name, local.role_name, "*")

  trusted_entities_services = distinct(compact(concat(
    slice(["lambda.amazonaws.com", "edgelambda.amazonaws.com"], 0, false ? 2 : 1),
    [for service in var.trusted_entities : try(tostring(service), "")]
  )))

  trusted_entities_principals = [
    for principal in var.trusted_entities : {
      type        = principal.type
      identifiers = tolist(principal.identifiers)
    }
    if !can(tostring(principal))
  ]
}

###########
# IAM role
###########

data "aws_iam_policy_document" "assume_role" {
  count = local.create_role ? 1 : 0

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = local.trusted_entities_services
    }

    dynamic "principals" {
      for_each = local.trusted_entities_principals
      content {
        type        = principals.value.type
        identifiers = principals.value.identifiers
      }
    }
  }

  dynamic "statement" {
    for_each = var.assume_role_policy_statements

    content {
      sid         = try(statement.value.sid, replace(statement.key, "/[^0-9A-Za-z]*/", ""))
      effect      = try(statement.value.effect, null)
      actions     = try(statement.value.actions, null)
      not_actions = try(statement.value.not_actions, null)

      dynamic "principals" {
        for_each = try(statement.value.principals, [])
        content {
          type        = principals.value.type
          identifiers = principals.value.identifiers
        }
      }

      dynamic "not_principals" {
        for_each = try(statement.value.not_principals, [])
        content {
          type        = not_principals.value.type
          identifiers = not_principals.value.identifiers
        }
      }

      dynamic "condition" {
        for_each = try(statement.value.condition, [])
        content {
          test     = condition.value.test
          variable = condition.value.variable
          values   = condition.value.values
        }
      }
    }
  }
}

resource "aws_iam_role" "lambda" {
  count = local.create_role ? 1 : 0

  name                  = local.role_name
  description           = var.role_description
  path                  = var.role_path
  force_detach_policies = var.role_force_detach_policies
  permissions_boundary  = var.role_permissions_boundary
  assume_role_policy    = data.aws_iam_policy_document.assume_role[0].json
  max_session_duration  = var.role_maximum_session_duration

  tags = merge(var.tags, var.role_tags)
}

##################
# Cloudwatch Logs
##################

data "aws_arn" "log_group_arn" {
  count = local.create_role ? 1 : 0

  arn = local.log_group_arn_regional
}

data "aws_iam_policy_document" "logs" {
  count = local.create_role && var.attach_cloudwatch_logs_policy ? 1 : 0

  statement {
    effect = "Allow"

    actions = compact([
      !var.use_existing_cloudwatch_log_group && var.attach_create_log_group_permission ? "logs:CreateLogGroup" : "",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ])

    resources = flatten([for _, v in ["%v:*", "%v:*:*"] : format(v, local.log_group_arn)])
  }
}

resource "aws_iam_policy" "logs" {
  count = local.create_role && var.attach_cloudwatch_logs_policy ? 1 : 0

  name   = "${local.policy_name}-logs"
  path   = var.policy_path
  policy = data.aws_iam_policy_document.logs[0].json
  tags   = var.tags
}

resource "aws_iam_role_policy_attachment" "logs" {
  count = local.create_role && var.attach_cloudwatch_logs_policy ? 1 : 0

  role       = aws_iam_role.lambda[0].name
  policy_arn = aws_iam_policy.logs[0].arn
}
