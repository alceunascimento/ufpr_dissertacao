# ---- Locale ----
Sys.setlocale("LC_TIME", "Portuguese_Brazil.1252")
Sys.setlocale("LC_NUMERIC", "C")

# ---- Opções globais de chunk ----
knitr::opts_chunk$set(
  echo       = FALSE,
  warning    = FALSE,
  message    = FALSE,
  error      = FALSE,
  fig.align  = "center",
  fig.width  = 10,
  fig.height = 5.5,
  dpi        = 150,
  dev        = "ragg_png",
  out.width  = "100%"
)

# ---- Opções R ----
options(
  scipen           = 999,
  digits           = 4,
  OutDec           = ",",
  knitr.kable.NA   = "—",
  tibble.print_max = 20
)

# ---- Pacotes ----
# bootstrap pacman 
if (!requireNamespace("pacman", quietly = TRUE)) {
  install.packages("pacman")
}
# pacotes necessários
pacman::p_load(
    dplyr, 
    tidyr, 
    ggplot2, 
    scales, 
    gt,
    stargazer, 
    thematic
)

# ---- Thematic: puxa cores e fontes do _brand.yml automaticamente ----
thematic::thematic_rmd(
  bg     = "auto",
  fg     = "auto",
  accent = "auto",
  font   = "auto"
)

# ---- gt: ABNT table helper ----
# Pipeline: gt → HTML → Quarto HTML table processing → Typst #table()
# Quarto converte o HTML do gt para Typst nativo automaticamente.
# O #show table no template Typst sobrescreve fonte e tamanho.
# Bordas ABNT: só horizontais (topo, abaixo do header, fundo). Sem linhas internas.
gt_abnt <- function(data, ...) {
  data |>
    gt(...) |>
    tab_options(
      table.border.top.style    = "solid",
      table.border.top.width    = px(1),
      table.border.bottom.style = "solid",
      table.border.bottom.width = px(1),
      column_labels.border.bottom.style = "solid",
      column_labels.border.bottom.width = px(1),
      table_body.hlines.style   = "none",
      table.background.color    = "transparent"
    )
}

# ---- Formatadores pt-BR reutilizáveis ----
fmt_num  <- scales::label_number(big.mark = ".", decimal.mark = ",", accuracy = 1)
fmt_pct  <- scales::label_percent(big.mark = ".", decimal.mark = ",", accuracy = 0.1)
fmt_brl  <- scales::label_currency(prefix = "R$ ", big.mark = ".", decimal.mark = ",", accuracy = 0.01)
fmt_data <- function(x) format(as.Date(x), "%d/%m/%Y")


#eof----------------------------------------------------------------------------