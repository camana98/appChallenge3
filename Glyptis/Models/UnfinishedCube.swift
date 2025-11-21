//
//  UnfinishedCube.swift
//  appChallenge3
//
//  Created by Vicenzo Másera on 18/11/25.
//

import Foundation

struct UnfinishedCube {
    let locationX: Float
    let locationY: Float
    let locationZ: Float
    
    let colorR: Float
    let colorG: Float
    let colorB: Float
    let colorA: Float
}

// Utilizado para posicionar blocos sem atribuir à uma escultura de forma desnecessariamente prévia
// Para transformar isso em Cube apenas criar uma nova escultura, dar um for rascunhoCube in rascunhosCubes
// e atribuir a nova escultura a cada cubo novo gerado, a nova escultura sendo a sculpture de seu init
