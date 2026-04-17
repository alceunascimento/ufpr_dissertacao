// ============================================================
// ufpr-dissertacao.typ
// Quarto pandoc template — UFPR Dissertação ABNT
//
// Pandoc variables injected by Quarto:
//   title, author, date, body, toc
//
// Custom YAML fields (top-level in artigo.qmd):
//   resumo, palavras-chave, abstract, keywords
//   committee, defense-date, city, year
//
// Custom YAML fields (under author[].metadata):
//   advisor, submission-note, course, department, degree
// ============================================================

// ─── 1. PAGE: base config — pre-textual phase (no numbering) ─
#set page(
  paper: "a4",
  margin: (top: 3cm, left: 3cm, bottom: 2cm, right: 2cm),
  numbering: none,
  header: none,
  footer: none,
)

// ─── 2. TYPOGRAPHY ───────────────────────────────────────────
// Fallback to Liberation Serif if Times New Roman not found
#set text(
  font: "Times New Roman",
  size: 12pt,
  lang: "pt",
  region: "BR",
)

// ─── 3. PARAGRAPH ────────────────────────────────────────────
// 1.5x line spacing: baseline = 12pt × 1.5 = 18pt
// leading = 18pt − 12pt = 6pt ≈ 0.5em
#set par(
  leading: 0.65em,
  spacing: 1.5em,
  first-line-indent: (amount: 1.5cm, all: true),
  justify: true,
)

// ─── 4. SECTION NUMBERING ────────────────────────────────────
#set heading(numbering: "1.1.1")

// ─── 5. HEADINGS ─────────────────────────────────────────────
// Show-set rule: cancela o size scaling e o weight por nível do Typst.
// Deve vir ANTES das show rules individuais.
#show heading: set text(size: 12pt, weight: "regular")

// Grid de alinhamento: coluna fixa (1.5cm) para o número —
// igual ao first-line-indent do corpo — e 1fr para o texto.
// Unnumbered headings ({.unnumbered}): it.numbering == none → só texto.

#show heading.where(level: 1): it => {
  v(2.5em, weak: true)
  if it.numbering != none {
    upper(strong(context grid(
      columns: (1.5cm, 1fr),
      align: (left + top, left + top),
      counter(heading).display(it.numbering),
      it.body,
    )))
  } else {
    upper(strong(it.body))
  }
  v(1.5em, weak: true)
}

#show heading.where(level: 2): it => {
  v(2.5em, weak: true)
  if it.numbering != none {
    upper(context grid(
      columns: (1.5cm, 1fr),
      align: (left + top, left + top),
      counter(heading).display(it.numbering),
      it.body,
    ))
  } else {
    upper(it.body)
  }
  v(1.5em, weak: true)
}

#show heading.where(level: 3): it => {
  v(2.5em, weak: true)
  if it.numbering != none {
    context grid(
      columns: (1.5cm, 1fr),
      align: (left + top, left + top),
      counter(heading).display(it.numbering),
      it.body,
    )
  } else {
    it.body
  }
  v(1.5em, weak: true)
}

#show heading.where(level: 4): it => {
  v(2.5em, weak: true)
  if it.numbering != none {
    context grid(
      columns: (1.5cm, 1fr),
      align: (left + top, left + top),
      counter(heading).display(it.numbering),
      it.body,
    )
  } else {
    it.body
  }
  v(1.5em, weak: true)
}


// ─── 6. CITAÇÃO DIRETA LONGA ─────────────────────────────────
// ABNT NBR 10520: recuo 4cm esquerda, 10pt, espaço simples
#show quote: it => {
  set text(size: 10pt)
  set par(
    leading: 0.5em,
    first-line-indent: 0pt,
    spacing: 0.5em,
  )
  pad(left: 4cm, top: 0.5em, bottom: 0.5em)[#it.body]
}
// ─── 7. FOOTNOTES ────────────────────────────────────────────
#set footnote.entry(
  separator: line(length: 5cm, stroke: 0.5pt),
  indent: 1em,
)
#show footnote.entry: set text(size: 10pt)



// ─── 8. FIGURAS E TABELAS (ABNT) ─────────────────────────────

// Caption acima (ABNT NBR 14724) — Typst 0.12+
#set figure.caption(position: top)

// Formato "Figura/Tabela N — descrição", 10pt
// Sintaxe []: igual ao template padrão do Quarto
#show figure.caption: it => [
  #set text(size: 10pt)
  #set par(first-line-indent: 0pt)
  #if it.numbering != none [
    #it.supplement
    #context it.counter.display(it.numbering)
    #sym.dash.en
  ]
  #it.body
]

// gt gera #set text(font: web-fonts) inline no bloco da tabela
// #show table sobrescreve porque tem precedência maior
#show table: set text(font: "Times New Roman", size: 10pt)



// ─── FRONT MATTER ────────────────────────────────────────────
// Each page uses #page(...) to override base page settings.
// No header, footer, or numbering on pre-textual pages.

// CAPA ─────────────────────────────────────────────────────────
#page(header: none, footer: none, numbering: none)[
  
  // Logo UFPR: top-left at (0,0). Adjust dx/dy/width after first render.
  #place(top + left, dx: 0pt, dy: 0pt)[
    #image("_templates/ufpr_logo.jpg", width: 100%)
  ]


  #align(center)[
    #v(0cm)
    #upper([Universidade Federal do Paraná])
    #v(3em)

    #upper(
      [{{ Autor Nome e Sobrenome }}]    )

    #v(8cm)
    #upper([Titulo da dissertação])

    #v(1fr)
    Curitiba \
    2026
  ]
]

// FOLHA DE ROSTO ───────────────────────────────────────────────
#page(header: none, footer: none, numbering: none)[
  #align(center)[
    #v(0cm)

    #upper(
      [{{ Autor Nome e Sobrenome }}]    )

    #v(10cm)
    #upper(strong[Titulo da dissertação])
  ]

  #v(2cm)

  // Nota de apresentação: bloco de 8.5cm alinhado à direita
  #align(right)[
    #box(width: 8.5cm)[
      #set par(first-line-indent: 0pt, spacing: 0.8em, leading: 0.6em, justify: true)
      #set text(size: 10pt)
      Dissertação apresentada como requisito parcial à obtenção de título de {{ titulo }}, Curso de {{ curso }}, Setor de {{ setor }} da Universidade Federal do Paraná.


      *Orientador:* Profª. Drª. {{ Nome Sobrenome }}
    ]
  ]

  #align(center)[
    #v(1fr)
    Curitiba \
    2026
  ]
]

// TERMO DE APROVAÇÃO ───────────────────────────────────────────
#page(header: none, footer: none, numbering: none)[
  #align(center)[
    #v(1cm)
    #upper(strong[Termo de Aprovação])
    #v(0.5cm)
    #upper[{{ Autor Nome e Sobrenome }}]
    #v(0.5cm)
    #upper(strong[Titulo da dissertação])
  ]

  #v(0.5cm)
  #set par(first-line-indent: 0pt)
  Dissertação apresentada como requisito parcial à obtenção de título de {{ titulo }}, Curso de {{ curso }}, Setor de {{ setor }} da Universidade Federal do Paraná.


  #v(0.5cm)
  #align(center)[
    #upper(strong[Banca Examinadora])
    #v(2cm)
    
    Prof.~Dr.~{{ Nome Sobrenome }} \
    #text(size: 11pt)[Universidade Federal do Paraná]
    #v(2cm)
    
    Prof.~Dr.~{{ Nome Sobrenome }} \
    #text(size: 11pt)[Universidade Federal do Paraná]
    #v(2cm)
    
    Prof.~Dr.~{{ Nome Sobrenome }} \
    #text(size: 11pt)[Universidade Federal do Paraná]

    #v(2cm)
    Curitiba, {{ DD }} de {{ mês }} de {{ AAAA }}.
  ]
]

// RESUMO ───────────────────────────────────────────────────────
#page(header: none, footer: none, numbering: none)[
  #v(1em)
  #align(center)[#upper(strong[Resumo])]
  #v(1em)
  #set par(leading: 0.5em, first-line-indent: 0pt, spacing: 0.5em)
  Texto do resumo em português.

  #v(1em)
  #set par(first-line-indent: 0pt)
  *Palavras-chave:* Palavra1; Palavra2; Palavra3
]

// ABSTRACT ─────────────────────────────────────────────────────
#page(header: none, footer: none, numbering: none)[
  #v(1em)
  #align(center)[#upper(strong[Abstract])]
  #v(1em)
  #set par(leading: 0.5em, first-line-indent: 0pt, spacing: 0.5em)
  Abstract text in English.

  #v(1em)
  #set par(first-line-indent: 0pt)
  *Keywords:* Keyword1; Keyword2; Keyword3
]

// ─── BODY PAGE STYLE ─────────────────────────────────────────
// From here onward: page number top-right, no rule, arabic from 1
#set page(
  header: context {
    align(right, text(12pt, counter(page).display("1")))
  },
  footer: none,
  numbering: "1",
)
#counter(page).update(1)

// ─── SUMÁRIO ──────────────────────────────────────────────────
// TOC page has no header (override with #page)
#page(header: none, footer: none, numbering: none)[
  #align(center)[#upper(strong[Sumário])]
  #outline(title: none, indent: auto)
]

// ─── LISTA DE FIGURAS ────────────────────────────────────────
// Manual outline: Quarto Typst does not support lof: true natively
#page(header: none, footer: none, numbering: none)[
  #align(center)[#upper(strong[Lista de Figuras])]
  #v(1em)
  #outline(title: none, target: figure.where(kind: "quarto-float-fig"))
]

// ─── LISTA DE TABELAS ────────────────────────────────────────
#page(header: none, footer: none, numbering: none)[
  #align(center)[#upper(strong[Lista de Tabelas])]
  #v(1em)
  #outline(title: none, target: figure.where(kind: "quarto-float-tbl"))
]

// ─── CORPO DO DOCUMENTO ──────────────────────────────────────
#pagebreak()
#block[
#heading(
level: 
1
, 
numbering: 
none
, 
[
Introdução
]
)
]
Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.

= Seção primária
<seção-primária>
Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.

#figure([
#table(
  columns: 3,
  align: (left,left,right,),
  table.header([Astronomical object], [R (km)], [mass (kg)],),
  table.hline(),
  [Sun], [696,000], [1988999999999999901022844480846],
  [Earth], [6,371], [5972000000000000327248442],
  [Moon], [1,737], [73400000000000002196202],
  [Mars], [3,390], [638999999999999976920828],
)
], caption: figure.caption(
position: top, 
[
Astronomical object
]), 
kind: "quarto-float-tbl", 
supplement: "Tabela", 
)
<tbl-planets>


Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.

== Seção secundária
<seção-secundária>
Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur #cite(<mishkinMonetaryTergetingInflation2000>, form: "prose");.

#figure([
#box(image("images/supply_demand.svg", width: 4in))
], caption: figure.caption(
position: bottom, 
[
Oferta e Demanda
]), 
kind: "quarto-float-fig", 
supplement: "Figura", 
)


Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur #cite(<sargentUnpleasantMonetaristArithmetic1981>, form: "prose");.

=== Seção terciária
<seção-terciária>
Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur:

#quote(block: true)[
"Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur." @mishkinEconomicsMoneyBanking2011
]

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.

==== Seção quaternária
<seção-quaternária>
Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.

#figure([
#table(
  columns: 4,
  align: (auto,left,right,center,),
  table.header([Default], [Left], [Right], [Center],),
  table.hline(),
  [12], [12], [12], [12],
  [123], [123], [123], [123],
  [1], [1], [1], [1],
)
], caption: figure.caption(
position: top, 
[
Titulo da Tabela
]), 
kind: "quarto-float-tbl", 
supplement: "Tabela", 
)
<tbl-qualquer>


Ver #ref(<tbl-qualquer>, supplement: [Tabela]).

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.

= Aspernatur aut odit aut fugit
<aspernatur-aut-odit-aut-fugit>
Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit.

#figure([
#{set text(font: ("system-ui", "Segoe UI", "Roboto", "Helvetica", "Arial", "sans-serif", "Apple Color Emoji", "Segoe UI Emoji", "Segoe UI Symbol", "Noto Color Emoji") , size: 12pt); table(
  columns: 3,
  align: (right,right,right,),
  table.header(table.cell(align: bottom + right, fill: rgb(255, 255, 255, 0%))[#set text(size: 1.0em , weight: "regular" , fill: rgb("#333333")); mpg], table.cell(align: bottom + right, fill: rgb(255, 255, 255, 0%))[#set text(size: 1.0em , weight: "regular" , fill: rgb("#333333")); cyl], table.cell(align: bottom + right, fill: rgb(255, 255, 255, 0%))[#set text(size: 1.0em , weight: "regular" , fill: rgb("#333333")); disp],),
  table.hline(),
  table.cell(align: horizon + right)[21,0], table.cell(align: horizon + right)[6], table.cell(align: horizon + right)[160],
  table.cell(align: horizon + right)[21,0], table.cell(align: horizon + right)[6], table.cell(align: horizon + right)[160],
  table.cell(align: horizon + right)[22,8], table.cell(align: horizon + right)[4], table.cell(align: horizon + right)[108],
  table.cell(align: horizon + right)[21,4], table.cell(align: horizon + right)[6], table.cell(align: horizon + right)[258],
  table.cell(align: horizon + right)[18,7], table.cell(align: horizon + right)[8], table.cell(align: horizon + right)[360],
  table.cell(align: horizon + right)[18,1], table.cell(align: horizon + right)[6], table.cell(align: horizon + right)[225],
  table.hline(),
  table.footer(table.cell(colspan: 3)[#strong[Fonte:] Henderson & Velleman (1981), #emph[Building Multiple Regression Models Interactively];.],
    table.cell(colspan: 3)[#strong[Nota:] Valores originais em unidades imperiais (mpg, cu.in., hp).],),
)}
], caption: figure.caption(
position: top, 
[
Consumo e deslocamento de automóveis selecionados, 1973-74
]), 
kind: "quarto-float-tbl", 
supplement: "Tabela", 
)
<tbl-mtcars-sample>


Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt.

#pagebreak()
#block[
#heading(
level: 
1
, 
numbering: 
none
, 
[
Conclusão
]
)
]
#pagebreak()

// ─── REFERÊNCIAS ─────────────────────────────────────────────
// Bloco com escopo próprio: cancela first-line-indent e alinha à esquerda.
#v(2em)
#[
  #set par(first-line-indent: 0pt)
  #strong[REFERÊNCIAS BIBLIOGRÁFICAS]
]
// Show-set rule: reduz espaçamento entre entradas da bibliografia.
// spacing: gap entre entradas; leading: espaço entre linhas dentro de uma entrada.
// first-line-indent: 0pt evita indentação indevida na primeira linha.
#show bibliography: set par(spacing: 0.85em, leading: 0.5em, first-line-indent: 0pt)
#bibliography("assets/bibliografia.bib", style: "assets/abnt_alceu.csl", title: none)
