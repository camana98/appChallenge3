# Glyptis: Realidade Esculpida 🧊📍🕶️

Glyptis é um editor de esculturas voxel (3D em blocos) nativo para iOS que combina criação artística, colaboração e Realidade Aumentada. Crie esculturas em blocos, salve tudo na nuvem com CloudKit e “ancore” suas obras no mundo real usando AR e geolocalização.

## 🌐 Visão Geral

A ideia central do Glyptis é simples:

> **Uma escultura única, múltiplas presenças no mundo real.**  

Você cria uma escultura voxel, ela é salva como um artefato canônico em CloudKit. A partir dela, podem existir várias “instâncias” daquela mesma obra em diferentes locais do mapa, cada uma com seu próprio grupo de colaboradores, sem jamais alterar o arquivo original do autor.

## ✨ Funcionalidades Principais

- 🧊 **Editor Voxel 3D**
  - Criação de esculturas em blocos (voxels) com coordenadas **X, Y, Z** e **cor**.
  - Manipulação de câmera em 3D para visualizar, navegar e editar a escultura.

- 🕶️ **Realidade Aumentada (AR)**
  - Renderização da escultura em **AR** usando o ambiente real como fundo.
  - “Ancoragem” da escultura em pontos do mundo físico, respeitando posição e orientação.

- 📍 **Geolocalização & Mapa**
  - Visualização das esculturas em um mapa com **MapKit**.
  - Cada escultura pode ter uma ou mais **localizações** no mundo (lat, long, altitude).

- ☁️ **Persistência na Nuvem com CloudKit**
  - Sincronização automática das esculturas e blocos entre dispositivos via iCloud.
  - Modelo de dados pensado para **autoria**, **instâncias locais** e **colaboração controlada**.

- 🤝 **Colaboração Localizada**
  - Vários usuários podem contribuir em **uma mesma localização** específica de uma escultura.
  - Alterações feitas por colaboradores afetam apenas aquela instância localizada, preservando o arquivo original do autor.

## 🛠 Tech Stack

- **Linguagem**
  - Swift 5+

- **UI**
  - SwiftUI
  - UIKit

- **3D & AR**
  - SceneKit  
  - RealityKit  
  - ARKit  

- **Backend & Banco de Dados**
  - Apple CloudKit (iCloud)

- **Mapas & Geolocalização**
  - MapKit

## 🧩 Arquitetura de Dados (CloudKit & Regras de Negócio)

O foco do Glyptis é um modelo de dados inteligente em CloudKit que diferencia nitidamente:

- **A obra original** (autoria)
- **As instâncias geolocalizadas** daquela obra
- **Os colaboradores locais** em cada instância

## 📄 Licença

Este projeto é distribuído sob a licença **MIT**.  
Você é livre para usar, copiar, modificar, mesclar, publicar e distribuir o código, desde que mantenha o aviso de copyright e a nota de licença original em qualquer cópia ou parte substancial do software.

Consulte o arquivo `LICENSE` para mais detalhes.
