# Ruby assignment -- Platformer

Mario-like platformer in *Ruby2D*

## Features

The game has the following features:
- simple **collisions** and gravity;
- character controls:
    - *a, d* for movement;
    - *space* for jump.
- one level with:
    - **platforms**,
    - deadly **holes**,
    - **obstacles**,
    - collectible **coins**,
    - moving **enemies**.
- levels can consist of multiple screens;
- *teleports* are used to move through them;
- player can:
    - **collect** coins;
    - **destroy** enemies;
    - **lose** hp (3 hearts).
- level **loading** from *json* file.

It isn't the most beautiful piece of code ever written... *but it works*

## Prerequisites

Project requires *Ruby* scripting language (with development kit like *MYSYS2* on Windows).

Also two *gems* are required: *ruby2d* and *json*. To install them type:

```cmd
gem install ruby2d
gem install json
```

## Run

Type in terminal ``ruby main.rb`` (with prerequisites installed).
