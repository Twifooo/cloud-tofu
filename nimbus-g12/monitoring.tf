resource "azurerm_monitor_action_group" "mail" {
  name                = "ag-${local.suffix}"
  resource_group_name = azurerm_resource_group.main.name
  short_name          = "nimbus"
  tags                = local.tags

  email_receiver {
    name          = "admin-mail"
    email_address = var.alert_email
  }
}

resource "azurerm_monitor_metric_alert" "cpu" {
  count               = 2
  name                = "alert-cpu-web${count.index + 1}-${local.suffix}"
  resource_group_name = azurerm_resource_group.main.name
  scopes              = [azurerm_linux_virtual_machine.web[count.index].id]
  description         = "CPU > 80% pendant 5 minutes"
  severity            = 2
  frequency           = "PT1M"
  window_size         = "PT5M"
  tags                = local.tags

  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachines"
    metric_name      = "Percentage CPU"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 80
  }

  action {
    action_group_id = azurerm_monitor_action_group.mail.id
  }
}