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
$for(by-author)$
      [$by-author.name.literal$]$sep$\
$endfor$
    )

    #v(8cm)
    #upper([$title$])

    #v(1fr)
$if(city)$
    $city$ \
$endif$
$if(year)$
    $year$
$endif$
  ]
]

// FOLHA DE ROSTO ───────────────────────────────────────────────
#page(header: none, footer: none, numbering: none)[
  #align(center)[
    #v(0cm)

    #upper(
$for(by-author)$
      [$by-author.name.literal$]$sep$\
$endfor$
    )

    #v(10cm)
    #upper(strong[$title$])
  ]

  #v(2cm)

  // Nota de apresentação: bloco de 8.5cm alinhado à direita
  #align(right)[
    #box(width: 8.5cm)[
      #set par(first-line-indent: 0pt, spacing: 0.8em, leading: 0.6em, justify: true)
      #set text(size: 10pt)
$if(submission-note)$
      $submission-note$
$endif$
$if(advisor)$

      *Orientador:* $advisor$
$endif$
    ]
  ]

  #align(center)[
    #v(1fr)
$if(city)$
    $city$ \
$endif$
$if(year)$
    $year$
$endif$
  ]
]

// TERMO DE APROVAÇÃO ───────────────────────────────────────────
#page(header: none, footer: none, numbering: none)[
  #align(center)[
    #v(1cm)
    #upper(strong[Termo de Aprovação])
    #v(0.5cm)
$for(by-author)$
    #upper[$by-author.name.literal$]
$endfor$
    #v(0.5cm)
    #upper(strong[$title$])
  ]

  #v(0.5cm)
  #set par(first-line-indent: 0pt)
$if(submission-note)$
  $submission-note$
$endif$

  #v(0.5cm)
  #align(center)[
    #upper(strong[Banca Examinadora])
$for(committee)$
    #v(2cm)
    
    $committee.name$ \
    #text(size: 11pt)[$committee.institution$]
$endfor$

    #v(2cm)
$if(defense-date)$
    Curitiba, $defense-date$.
$endif$
  ]
]

// RESUMO ───────────────────────────────────────────────────────
$if(resumo)$
#page(header: none, footer: none, numbering: none)[
  #v(1em)
  #align(center)[#upper(strong[Resumo])]
  #v(1em)
  #set par(leading: 0.5em, first-line-indent: 0pt, spacing: 0.5em)
  $resumo$
  #v(1em)
  #set par(first-line-indent: 0pt)
  *Palavras-chave:* $if(palavras-chave)$$palavras-chave$$endif$
]
$endif$

// ABSTRACT ─────────────────────────────────────────────────────
$if(abstract)$
#page(header: none, footer: none, numbering: none)[
  #v(1em)
  #align(center)[#upper(strong[Abstract])]
  #v(1em)
  #set par(leading: 0.5em, first-line-indent: 0pt, spacing: 0.5em)
  $abstract$
  #v(1em)
  #set par(first-line-indent: 0pt)
  *Keywords:* $if(keywords)$$keywords$$endif$
]
$endif$

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
$if(toc)$
#page(header: none, footer: none, numbering: none)[
  #align(center)[#upper(strong[Sumário])]
  #outline(title: none, indent: auto)
]
$endif$

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
$body$

// ─── REFERÊNCIAS ─────────────────────────────────────────────
// Bloco com escopo próprio: cancela first-line-indent e alinha à esquerda.
#v(2em)
#[
  #set par(first-line-indent: 0pt)
  #strong[REFERÊNCIAS BIBLIOGRÁFICAS]
]
$if(bibliography)$
// Show-set rule: reduz espaçamento entre entradas da bibliografia.
// spacing: gap entre entradas; leading: espaço entre linhas dentro de uma entrada.
// first-line-indent: 0pt evita indentação indevida na primeira linha.
#show bibliography: set par(spacing: 0.85em, leading: 0.5em, first-line-indent: 0pt)
#bibliography($for(bibliography)$"$it$"$sep$, $endfor$, style: "assets/abnt_alceu.csl", title: none)
$endif$