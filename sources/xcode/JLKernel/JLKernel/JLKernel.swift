//
//  JLKernel.swift
//  JLKernel
//
//  Created by Camilo on 19-08-26.
//

import Foundation

public class Kernel {
  
  public static func logo() {
    print("""
      █ █▀█ █▀▀ █▀█ █▀▄█ █▀▀ █   █   █▀▀
     ░▓ █▀▓ ▀▀▓ █ ▓ █  ▓ ▓▀  ▓░  ▓░  ▓▀ 
    ▀▀▀ ▀ ▀ ▀▀▀ ▀▀▀ ▀  ▀ ▀▀▀ ▀▀▀ ▀▀▀ ▀▀▀
    \t\t\t\tv\(Version.semantic())
    \t\thttps://jasonelle.com/
    """)
  }
}
