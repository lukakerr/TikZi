//
//  TikZiViewController.swift
//  TikZi
//
//  Created by Luka Kerr on 21/9/19.
//  Copyright © 2019 Luka Kerr. All rights reserved.
//

import Cocoa
import PDFKit

class TikZiViewController: NSViewController {

  @IBOutlet var tikziTextView: NSTextView!
  @IBOutlet weak var tikziPDFView: PDFView!
  @IBOutlet weak var tikziErrorField: NSTextField!
  @IBOutlet weak var tikziProgressIndicator: NSProgressIndicator!

  private var debouncedGeneratePDF: Debouncer!

  override func viewDidLoad() {
    super.viewDidLoad()

    tikziTextView.font = NSFont(name: "SF Mono", size: 16)

    tikziPDFView.scaleFactor = 1
    tikziPDFView.autoScales = true
    tikziPDFView.backgroundColor = .white
    tikziPDFView.enclosingScrollView?.verticalScroller?.alphaValue = 0

    if #available(OSX 10.14, *) {
      tikziPDFView.pageShadowsEnabled = false
    }

    tikziErrorField.isHidden = true

    tikziProgressIndicator.isHidden = true

    NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event -> NSEvent? in
      self.keyDown(with: event)
      return event
    }

    debouncedGeneratePDF = Debouncer(delay: 0.4) {
      self.generateTikzPDF()
    }
  }

  override func keyDown(with event: NSEvent) {
    debouncedGeneratePDF.call()
  }

  private func generateTikzPDF() {
    guard
      let texFile = Template.texPath,
      let texFileURL = Template.texURL
    else { return }

    tikziProgressIndicator.isHidden = false
    tikziProgressIndicator.startAnimation(nil)

    let latex = Template.getLaTeX(tikz: tikziTextView.string)

    DispatchQueue.global(qos: .userInitiated).async {
      try? latex.write(to: texFileURL, atomically: true, encoding: .utf8)

      let (_, _, didError) = Command.run(args: "-c", "pdflatex -halt-on-error \(texFile)")

      guard
        let pdfFile = Template.pdfURL,
        let pdfDocument = PDFDocument(url: pdfFile.absoluteURL)
      else { return }

      DispatchQueue.main.async {
        self.tikziErrorField.isHidden = !didError
        self.tikziPDFView.document = pdfDocument
        self.tikziProgressIndicator.isHidden = true
        self.tikziProgressIndicator.stopAnimation(nil)
      }
    }
  }

}
