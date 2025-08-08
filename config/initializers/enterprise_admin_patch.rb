module EnterpriseAdminPlanOverride
  def plan_name
    return "Enterprise" if self.id == 1
    super
  end

  def enabled_features
    if self.id == 1
      %w[
        inbound_emails help_center campaigns team_management channel_twitter
        channel_facebook channel_email channel_instagram captain_integration
        sla custom_roles audit_logs disable_branding response_bot
        help_center_embedding_search captain_integration_v2 custom_branding
        custom_widgets custom_reports webhooks advanced_automation
      ]
    else
      super
    end
  end

  def feature_enabled?(*)
    self.id == 1 ? true : super
  end

  def has_feature?(*)
    self.id == 1 ? true : super
  end

  def ee?
    self.id == 1 ? true : (defined?(super) ? super : false)
  end

  def usage_limits
    if self.id == 1
      { agents: 9999, conversations: 999_999, captain: 9999 }
    else
      super
    end
  end
end

Rails.application.config.to_prepare do
  if defined?(Enterprise::Account::PlanUsageAndLimits)
    Enterprise::Account::PlanUsageAndLimits.prepend(EnterpriseAdminPlanOverride)
  end
end
