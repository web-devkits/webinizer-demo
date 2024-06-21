# Tutorial for building and running Asteroids WASM demo with Webinizer

## How to build Asteroids with Webinizer

1.  **`Main page`** - Click `Get Started` in Webinizer main page to enter the project list page.

2.  **`Get started page`** - Click the `SELECT` button of the Asteroids project.

3.  **`Editor page`** - Click the `Edit` in the top navigation panel to enter the `Project edit`
    page.

    - Click `File` -> `New File` to create empty editor panel.
    - Input following content and save as `./CMakeLists.txt` target.

      ```cmake
      cmake_minimum_required(VERSION 3.0)
      project(Asteroids VERSION 1.0)
      set(CMAKE_C_STANDARD 99)
      add_compile_options(-Wall)
      find_package(SDL2 REQUIRED)
      include_directories(${SDL2_INCLUDE_DIRS})
      set(SOURCES
          asteroids/main.c
          asteroids/vector.c
          asteroids/player.c
          asteroids/asteroids.c
          asteroids/renderer.c)
      add_executable(Asteroid ${SOURCES})
      target_link_libraries(Asteroid m ${SDL2_LIBRARIES})
      ```

4.  **`Basic config page`** - Click `BUILD STEPS ->` in the lower right corner or `Steps` in the top
    navigation panel to enter the `Build steps` page.

5.  **`Build steps page`**

    - Select the `static` build target and Webinizer will prompt you with the recommended build
      steps for the project.

    - Click `YES` to accept the recommendation.

    - Click `BUILD ->` in the lower right corner or `Build` in the top navigation panel to enter the
      `Build` page.

6.  **`Build page`**

    - Click the `BUILD` button to trigger the build and some recipes will show in several rounds of
      build.

    - `Recipe for checking project dependent packages`- Click the `APPLY RECIPE` button to accept
      the recipe.

      > Note. _We detected dependent packages required for the project and would like to use
      > Emscripten specific build options for them to use the ported Wasm versions. We may modify
      > the CMakeLists.txt file to remove unnecessary dependent packages statements._

    - `Recipe for main loop issue` - Click `Edit` in the top navigation panel and we’ll be directed
      to the `Editor` page.

      > Note. _We are building an application that is running on the main thread, which is using an
      > infinite loop to render animations and thread-blocking. As the recipe suggested, we should
      > modify our source code with specific API provided by Emscripten._

7.  **`Editor page`**

    - Select the file `asteroids -> main.c` from the `Project Explorer` sidebar and modify the code
      as below. Then click the `SAVE` button to save the changes.

      ```diff
        // src/main.c
        #include <SDL.h>
        #include <stdio.h>
        #include <stdlib.h>
        #include "renderer.h"
        #include "player.h"
        #include "asteroids.h"
      + #include <emscripten.h>


      - int main (int argc, char* args[]) {
      -
      -   //SDL Window setup
      -   if (init(SCREEN_WIDTH, SCREEN_HEIGHT) == 1) {
      -
      -      return 0;
      -   }
      -
      - int i = 0;
      - int j = 0;
      - int offset = 0;
      - struct vector2d translation = {-SCREEN_WIDTH / 2, -SCREEN_HEIGHT / 2};
      -
      - //set up icons used to represent player lives
      - for (i = 0; i < LIVES; i++) {
      -
      -   init_player(&lives[i]);
      -   lives[i].lives = 1;
      -
      -   //shrink lives
      -   for (j = 0; j < P_VERTS; j++) {
      -
      -     divide_vector(&lives[i].obj_vert[j], 2);
      -   }
      -
      -    //convert screen space vector into world space
      -    struct vector2d top_left = {20 + offset, 20};
      -    add_vector(&top_left, &translation);
      -    lives[i].location = top_left;
      -    update_player(&lives[i]);
      -    offset += 20;
      -  }
      -
      - //set up player and asteroids in world space
      -  init_player(&p);
      -  init_asteroids(asteroids, ASTEROIDS);

        int sleep = 0;
        int quit = 0;
        SDL_Event event;
      - Uint32 next_game_tick = SDL_GetTicks();
      + Uint32 next_game_tick;
      - while(quit == 0) {
      + void mainLoopWrapper(){
      +   if(quit == 0) {
        ...
        ...
          }
        }
      + int main (int argc, char* args[]) {
      +
        + //SDL Window setup
        + if (init(SCREEN_WIDTH, SCREEN_HEIGHT) == 1) {
      +
        +   return 0;
        + }
      +
      + int i = 0;
      + int j = 0;
      + int offset = 0;
      + struct vector2d translation = {-SCREEN_WIDTH / 2, -SCREEN_HEIGHT / 2};
      +
      + //set up icons used to represent player lives
      + for (i = 0; i < LIVES; i++) {
      +
      +   init_player(&lives[i]);
      +   lives[i].lives = 1;
      +
      +   //shrink lives
      +   for (j = 0; j < P_VERTS; j++) {
      +
      +     divide_vector(&lives[i].obj_vert[j], 2);
      +   }
      +
      +   //convert screen space vector into world space
      +   struct vector2d top_left = {20 + offset, 20};
      +   add_vector(&top_left, &translation);
      +   lives[i].location = top_left;
      +   update_player(&lives[i]);
      +   offset += 20;
      + }
      +
      + //set up player and asteroids in world space
      + init_player(&p);
      + init_asteroids(asteroids, ASTEROIDS);
      +
      + next_game_tick = SDL_GetTicks();
      +
      + //render loop
      + emscripten_set_main_loop(mainLoopWrapper, 0, 1);
      ...
      }
      ```

    - Select the file `CMakeLists.txt` from the `Project Explorer` sidebar and modify the code as
      below. Then click the `SAVE` button to save the changes.

      ```diff
        // CMakeLists.txt
        project(Asteroids VERSION 1.0)
      + # to generate html target
      + set(CMAKE_EXECUTABLE_SUFFIX ".html")
      ```

      > NOTE. _The demo is using the `html` generated by Emscripten, generally `html` target could
      > be generated with `emcc/em++ -o output.html`, which is not a suitable approach when
      > integrating with `emcmake` and `emmake`. The above suggestion is one approach to build
      > `html` target, you could also find other ways that work._

    - Click `Build` in the top navigation panel to route us back to the `Build` page.

8.  `Recipe for modularize JS output option` - Click the `APPLY RECIPE` button to accept the recipe
    as well.

    > `The html target file is not compatible with build options "-sMODULARIZE -sEXPORT_NAME=Module_"`

9.  **`Build page`** - Click the `BUILD` button to trigger the build again.

After a while, it will show `Build successfully!` on the page.

## How to run the demo

- Below are the generated files that are required to run the demo:

  - `Asteroids.js`
  - `Asteroids.wasm`
  - `Asteroids.html`

- Set up the server

  Run the script to copy all the files required and start the server.

  ```sh
  ./run.sh
  ```

````

- Run in the browser

  ```
  http://localhost:8080
  ```

- Try it!
  - Arrow keys `up, down, left, right` to control movement, `space` to fire
````
