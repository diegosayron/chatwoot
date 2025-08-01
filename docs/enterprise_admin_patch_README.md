# Patch Enterprise para Conta Admin (id=1) — Chatwoot

Este projeto utiliza um patch Ruby para garantir que a conta Admin (id=1) tenha acesso total aos recursos do plano Enterprise, independente das configurações do banco de dados ou painel.

## Objetivo

- **Liberar todos os recursos, limites e features enterprise apenas para o admin (id=1).**
- **Permitir planos restritos ou personalizados para demais clientes (multi-tenant).**
- **Facilitar manutenção e atualizações do Chatwoot, sem modificar arquivos do core.**

---

## Como funciona o patch

- O arquivo `config/initializers/enterprise_admin_patch.rb` implementa uma extensão ("monkey patch") via Ruby, sobrescrevendo apenas os métodos necessários da classe `Enterprise::Account::PlanUsageAndLimits`.
- Para a conta admin (id=1), as funções `plan_name`, `enabled_features` e `usage_limits` retornam sempre o máximo possível.
- Para todas as demais contas, o comportamento original do Chatwoot é mantido.
- **O arquivo original do Chatwoot NÃO é alterado.** Assim, é seguro atualizar o sistema posteriormente.

---

## Exemplo do Patch (não edite o core, só use o initializer!)

```ruby
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

Enterprise::Account::PlanUsageAndLimits.prepend(EnterpriseAdminPlanOverride)
```

---

## Perguntas frequentes

**Preciso avisar alguém sobre esse patch?**
- Se você trabalha em equipe ou versiona o projeto, documente este arquivo e sua função aqui.

**O patch se perde em atualizações?**
- Não, o patch permanece enquanto o arquivo estiver em `config/initializers/`.

**Posso remover ou editar facilmente?**
- Sim, basta remover ou editar o arquivo, sem afetar o core do Chatwoot.

**Como saber se está funcionando?**
- A conta admin (id=1) terá acesso a todos os recursos enterprise automaticamente. Teste logando como admin.

---

## Boas práticas

- Nunca sobrescreva arquivos originais do Chatwoot.
- Adicione este README ao versionamento, junto com o patch.
- Documente qualquer ajuste adicional aqui para futuras manutenções.

---

Dúvidas? Fale com o responsável técnico ou envie para contato@inbox360.com.br.