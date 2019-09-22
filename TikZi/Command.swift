//
//  Command.swift
//  TikZi
//
//  Created by Luka Kerr on 21/9/19.
//  Copyright © 2019 Luka Kerr. All rights reserved.
//

import Cocoa

final class Command {

  private static let texPaths = [
    Template.resourcePath,
    "/Library/TeX/texbin",
    "/Library/TeX/Root/bin"
  ]

  public static func run(args: String...) -> (stdout: [String], stderr: [String], error: Bool) {
    let cmd = Process()

    var stdout: [String] = []
    var stderr: [String] = []

    let outpipe = Pipe()
    cmd.standardOutput = outpipe

    let errpipe = Pipe()
    cmd.standardError = errpipe

    var env = ProcessInfo.processInfo.environment
    let paths = Command.texPaths.joined(separator: ":") + ":"
    env["PATH"] = paths + env["PATH"]!

    cmd.environment = env
    cmd.launchPath = "/bin/sh"
    cmd.currentDirectoryPath = Template.resourcePath
    cmd.arguments = args

    cmd.launch()

    let outdata = outpipe.fileHandleForReading.readDataToEndOfFile()
    if var string = String(data: outdata, encoding: .utf8) {
      string = string.trimmingCharacters(in: .newlines)
      stdout = string.components(separatedBy: "\n")
    }

    let errdata = errpipe.fileHandleForReading.readDataToEndOfFile()
    if var string = String(data: errdata, encoding: .utf8) {
      string = string.trimmingCharacters(in: .newlines)
      stderr = string.components(separatedBy: "\n")
    }

    cmd.waitUntilExit()

    let error = cmd.terminationStatus != 0

    return (stdout, stderr, error)
  }

}
