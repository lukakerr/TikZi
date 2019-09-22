//
//  Template.swift
//  TikZi
//
//  Created by Luka Kerr on 21/9/19.
//  Copyright © 2019 Luka Kerr. All rights reserved.
//

import Cocoa

final class Template {

  public static let resourcePath = Bundle.main.resourcePath!

  public static let tex = "contents.tex"
  public static let pdf = "contents.pdf"
  public static let svg = "contents.svg"

  public static let texPath = Bundle.main.path(forResource: "contents", ofType: "tex")
  public static let texURL = Bundle.main.url(forResource: "contents", withExtension: "tex")

  public static let pdfPath = Bundle.main.path(forResource: "contents", ofType: "pdf")
  public static let pdfURL = Bundle.main.url(forResource: "contents", withExtension: "pdf")

  public static let svgPath = Bundle.main.path(forResource: "contents", ofType: "svg")
  public static let svgURL = Bundle.main.url(forResource: "contents", withExtension: "svg")

  public static func getLaTeX(tikz: String) -> String {
    return """
    \\documentclass[10pt,a4paper]{standalone}

    \\usepackage{tikz}
    \\usepackage{amsmath}
    \\usepackage[T1]{fontenc}
    \\usepackage[utf8]{inputenc}
    \\usetikzlibrary{automata, er, trees, positioning}

    \\begin{document}

    \\begin{tikzpicture}[shorten >= 0.5pt, node distance=1cm, auto]
      \(tikz)
    \\end{tikzpicture}

    \\end{document}
    """
  }

}
