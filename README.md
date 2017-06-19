## Platformer

Basic framework to bootstrap a platformer.

## project structure

README.md
conf.lua
main.lua
|-- common
|  |-- game.lua
|  |-- version.lua
|  |-- build.lua  
|-- design
|-- entities
|-- gamestates
  |-- debug
|-- modules
|-- resources
  |-- fonts
  |-- maps
  |-- music
  |-- shaders

## Events

* GameOver
* ResetGame
* Win
* (Checkpoint)

## Game states

- Start
- Play
  |- Level
     |- Debug
     |- Paused
     |- Win


* Start
* Play
* Paused
* GameplayIn/GameplayOut
* Loading
* Win
* Debug
