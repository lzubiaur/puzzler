## TODO

* credits
* more games (from a webpage?)
* tips
* reward player with tips if he watch an ads
* push notifications
* rate plugins https://github.com/hotchemi/Android-Rate
* piece becomes transparent when moving

## credits
 Background patterns from Subtle Patterns
 Puzzles from Polyform Puzzler

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
* ResetLevel
* WinLevel
* WinSeason
* (Checkpoint)

##

Search for the following

TODO
HACK
XXX
FIXME
LZU

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
