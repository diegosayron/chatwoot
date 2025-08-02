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
        help_center_embedding_search captain_integration_v2
      ]
    else
      super
    end
  end

  def usage_limits
    if self.id == 1
      { agents: 9999, conversations: 999_999, captain: 9999 }
    else
      super
    end
  end
end

# Prepend o patch na classe já existente
Enterprise::Account::PlanUsageAndLimits.prepend(EnterpriseAdminPlanOverride)