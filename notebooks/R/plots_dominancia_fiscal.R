# ============================================================
# plots_dominancia_fiscal.R
#
# Gera dois plots para a resenha de Blanchard (2004):
#   "Fiscal Dominance and Inflation Targeting: Lessons from Brazil"
#
# Plot 1 — Crise de 2002: EMBI+ e câmbio R$/USD (1999–2004)
# Plot 2 — Dívida Bruta do Governo Geral % PIB (2006–presente)
#
# Dados: BCB / SGS (API pública, sem autenticação)
# Pacotes: rbcb, ggplot2, patchwork, dplyr, scales, here
#
# Como usar:
#   source(here::here("R", "plots_dominancia_fiscal.R"))
#   ou executar direto: Rscript R/plots_dominancia_fiscal.R
# ============================================================

# ── Pacotes ──────────────────────────────────────────────────────────────────

if (!requireNamespace("pacman", quietly = TRUE)) install.packages("pacman")
pacman::p_load(rbcb, ggplot2, patchwork, dplyr, scales, here)

# ── Paleta: brand.yml ─────────────────────────────────────────────────────────

pal <- list(
  primaria   = "#1F4E79",
  secundaria = "#2F5597",
  acento     = "#C00000",
  cinza_900  = "#111827",
  cinza_700  = "#374151",
  cinza_500  = "#6B7280",
  cinza_200  = "#E5E7EB"
)

# ── Tema ──────────────────────────────────────────────────────────────────────

tema_base <- theme_minimal(base_size = 10) +
  theme(
    plot.title    = element_text(face = "bold", size = 11, color = pal$cinza_900),
    plot.subtitle = element_text(size = 9, color = pal$cinza_700),
    plot.caption  = element_text(size = 7.5, color = pal$cinza_500, hjust = 0,
                                 lineheight = 1.3),
    panel.grid.minor  = element_blank(),
    panel.grid.major  = element_line(color = pal$cinza_200, linewidth = 0.35),
    axis.title    = element_text(size = 8.5, color = pal$cinza_700),
    axis.text     = element_text(size = 8,   color = pal$cinza_700),
    plot.margin   = margin(8, 14, 6, 8)
  )

# ── Download dos dados ────────────────────────────────────────────────────────
#
# Códigos SGS (BCB):
#   7244  — EMBI+ Risco Brasil (pontos-base, mensal)
#   3697  — Taxa de câmbio livre USD/BRL, venda, fim de período (R$, mensal)
#   13762 — Dívida Bruta do Governo Geral (% PIB, mensal, a partir de jun/2006)
#
# Se 3697 retornar erro, tente: 3696 (compra, fim de período)
# Referência: https://www.bcb.gov.br/estatisticas/tabelaespecial

message("Baixando série 7244 (EMBI+)...")
embi_raw <- rbcb::get_series(7244,
                              start_date = "1999-01-01",
                              end_date   = "2004-12-31")
names(embi_raw) <- c("data", "valor")
embi <- embi_raw |> filter(!is.na(valor))

message("Baixando série 3697 (câmbio R$/USD)...")
cambio_raw <- rbcb::get_series(3697,
                                start_date = "1999-01-01",
                                end_date   = "2004-12-31")
names(cambio_raw) <- c("data", "valor")
cambio <- cambio_raw |> filter(!is.na(valor))

message("Baixando série 13762 (DBGG % PIB)...")
dbgg_raw <- rbcb::get_series(13762, start_date = "2006-01-01")
names(dbgg_raw) <- c("data", "valor")
dbgg <- dbgg_raw |> filter(!is.na(valor))

message("Séries baixadas.")

# ── Plot 1 — Crise de 2002 ────────────────────────────────────────────────────
#
# Janela da crise eleitoral e pós-eleitoral: jul/2002 a mar/2003
# Mecanismo de Blanchard (2004): maior risco soberano → saída de capitais
# → depreciação do real → pressão inflacionária

crise_ini <- as.Date("2002-07-01")
crise_fim <- as.Date("2003-03-31")

# Painel A: EMBI+
p1a <- ggplot(embi, aes(x = data, y = valor)) +
  annotate("rect",
           xmin = crise_ini, xmax = crise_fim,
           ymin = -Inf, ymax = Inf,
           fill = pal$acento, alpha = 0.10) +
  annotate("text",
           x     = as.Date("2002-10-01"),
           y     = max(embi$valor, na.rm = TRUE) * 0.88,
           label = "Crise eleitoral\n(jul/2002–mar/2003)",
           hjust = 0.5, size = 2.7, lineheight = 0.95,
           color = pal$acento, fontface = "italic") +
  geom_line(color = pal$acento, linewidth = 0.85) +
  scale_x_date(date_breaks = "1 year", date_labels = "%Y",
               expand = expansion(mult = c(0.01, 0.01))) +
  scale_y_continuous(
    labels = scales::label_number(big.mark = ".", decimal.mark = ",",
                                  accuracy = 1)
  ) +
  labs(title = "EMBI+ Brasil — prêmio de risco soberano (pontos-base)",
       y = "Pontos-base", x = NULL) +
  tema_base

# Painel B: Câmbio R$/USD
p1b <- ggplot(cambio, aes(x = data, y = valor)) +
  annotate("rect",
           xmin = crise_ini, xmax = crise_fim,
           ymin = -Inf, ymax = Inf,
           fill = pal$acento, alpha = 0.10) +
  geom_line(color = pal$primaria, linewidth = 0.85) +
  scale_x_date(date_breaks = "1 year", date_labels = "%Y",
               expand = expansion(mult = c(0.01, 0.01))) +
  scale_y_continuous(
    labels = scales::label_number(big.mark = ".", decimal.mark = ",",
                                  accuracy = 0.1)
  ) +
  labs(title = "Taxa de câmbio R$/US$ — venda, fim de período",
       y = "R$/US$", x = NULL) +
  tema_base

# Composição
plot1 <- p1a / p1b +
  plot_annotation(
    title    = "Figura 1 — Co-movimento entre risco soberano e câmbio: Brasil 1999–2004",
    subtitle = paste0("A depreciação do real como efeito da deterioração fiscal esperada ",
                      "— mecanismo central de Blanchard (2004)"),
    caption  = paste0(
      "Fonte: Banco Central do Brasil — SGS séries 7244 (EMBI+) e 3697 (taxa de câmbio).\n",
      "Área sombreada: período de crise eleitoral e pós-eleitoral (jul/2002–mar/2003)."
    ),
    theme = theme(
      plot.title    = element_text(face = "bold", size = 11, color = pal$cinza_900),
      plot.subtitle = element_text(size = 9, color = pal$cinza_700),
      plot.caption  = element_text(size = 7.5, color = pal$cinza_500,
                                   hjust = 0, lineheight = 1.3),
      plot.margin   = margin(8, 14, 8, 8)
    )
  )

# ── Plot 2 — Trajetória da dívida bruta ───────────────────────────────────────
#
# DBGG % PIB: a partir de jun/2006 (metodologia BACEN)
# Limiar de dominância fiscal (~85% PIB com meta de 3%) conforme Werlang (2025),
# que calibra o modelo de Araújo et al. (2020) com dados recentes.

# Pontos de anotação dos episódios
eps <- data.frame(
  x     = as.Date(c("2010-01-01", "2015-07-01", "2020-06-01")),
  y     = c(  61.5,       72.5,        93.5),
  label = c("Crise\n2008–09", "Deterioração\nfiscal\n2014–16", "Pandemia\n2020")
)

plot2 <- ggplot(dbgg, aes(x = data, y = valor)) +
  # Faixas de episódios
  annotate("rect",
           xmin = as.Date("2014-07-01"), xmax = as.Date("2017-06-30"),
           ymin = -Inf, ymax = Inf,
           fill = "darkorange", alpha = 0.08) +
  annotate("rect",
           xmin = as.Date("2020-03-01"), xmax = as.Date("2022-01-01"),
           ymin = -Inf, ymax = Inf,
           fill = pal$secundaria, alpha = 0.08) +
  # Limiar de dominância fiscal
  geom_hline(yintercept = 85,
             linetype = "dashed", color = pal$acento, linewidth = 0.7) +
  annotate("text",
           x     = min(dbgg$data) + 90,
           y     = 86.8,
           label = "Limiar estimado de dominância fiscal — meta 3% a.a. (Werlang, 2025: ~85% PIB)",
           hjust = 0, size = 2.55, color = pal$acento) +
  # Série principal
  geom_area(fill = pal$primaria, alpha = 0.10) +
  geom_line(color = pal$primaria, linewidth = 0.9) +
  # Anotações de episódios
  geom_text(data = eps, aes(x = x, y = y, label = label),
            size = 2.5, color = pal$cinza_500, lineheight = 0.9) +
  scale_x_date(date_breaks = "2 years", date_labels = "%Y",
               expand = expansion(mult = c(0.01, 0.02))) +
  scale_y_continuous(
    limits = c(55, NA),
    labels = scales::label_number(accuracy = 1, suffix = "%",
                                  big.mark = ".", decimal.mark = ",")
  ) +
  labs(
    title    = "Figura 2 — Dívida Bruta do Governo Geral (% PIB): 2006–presente",
    subtitle = paste0("A trajetória da dívida e a proximidade ao limiar ",
                      "de dominância fiscal estimado por Werlang (2025)"),
    x = NULL, y = "% do PIB",
    caption  = paste0(
      "Fonte: Banco Central do Brasil — SGS série 13762 (DBGG % PIB, metodologia a partir de jun/2006).\n",
      "Área laranja: deterioração fiscal 2014–2016. Área azul: pandemia 2020.\n",
      "Linha tracejada: limiar estimado de dominância fiscal para meta de inflação de 3% a.a. (Werlang, 2025)."
    )
  ) +
  tema_base

# ── Salvar ────────────────────────────────────────────────────────────────────

dir.create(here::here("notebooks", "images"), showWarnings = FALSE, recursive = TRUE)

ggsave(
  filename = here::here("notebooks", "images", "plot_crise_2002.png"),
  plot     = plot1,
  width    = 6.5, height = 5.5, dpi = 150
)
message("Plot 1 salvo: notebooks/images/plot_crise_2002.png")

ggsave(
  filename = here::here("notebooks", "images", "plot_dbgg.png"),
  plot     = plot2,
  width    = 6.5, height = 4.5, dpi = 150
)
message("Plot 2 salvo: notebooks/images/plot_dbgg.png")

message("\nProntos. Inclua no artigo.qmd com:\n",
        "  knitr::include_graphics(here::here('notebooks','images','plot_crise_2002.png'))\n",
        "  knitr::include_graphics(here::here('notebooks','images','plot_dbgg.png'))")
