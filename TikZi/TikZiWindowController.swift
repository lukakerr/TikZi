//
//  TikZiWindowController.swift
//  TikZi
//
//  Created by Luka Kerr on 21/9/19.
//  Copyright © 2019 Luka Kerr. All rights reserved.
//

import Cocoa

class TikZiWindowController: NSWindowController {

  @IBAction func exportSVG(sender: NSMenuItem) {
    guard let _ = Template.pdfPath else { return }

    DispatchQueue.global(qos: .userInitiated).async {
      let _ = Command.run(args: "-c", "pdf2svg \(Template.pdf) \(Template.svg)")

      guard let svgFile = Template.svgURL else { return }

      DispatchQueue.main.async {
        let dialog = NSSavePanel()

        dialog.title = "Export SVG"
        dialog.allowedFileTypes = ["svg"]
        dialog.canCreateDirectories = true

        if dialog.runModal() == .OK {
          guard let url = dialog.url else { return }

          let svgData = try? Data(contentsOf: svgFile)
          try? svgData?.write(to: url, options: .atomic)
        }
      }
    }
  }

  @IBAction func exportPDF(sender: NSMenuItem) {
    guard let pdfFile = Template.pdfURL else { return }

    let dialog = NSSavePanel()

    dialog.title = "Export PDF"
    dialog.allowedFileTypes = ["pdf"]
    dialog.canCreateDirectories = true

    if dialog.runModal() == .OK {
      guard let url = dialog.url else { return }

      let pdfData = try? Data(contentsOf: pdfFile)
      try? pdfData?.write(to: url, options: .atomic)
    }
  }

}
