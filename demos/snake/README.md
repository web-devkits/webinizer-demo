# Tutorial for building and running Snake WASM demo with Webinizer

## How to build Snake with Webinizer

1. **`Main page`** - Click `Get Started` in Webinizer main page to enter the project list page.

2. **`Get started page`** - Click the `SELECT` button of the Snake project to enter the
   `Basic config` page.

3. **`Basic config page`** - Click `BUILD STEPS ->` in the lower right corner or `Steps` in the top
   navigation panel to enter the `Build steps` page.

4. **`Build steps page`**

   - Select the `static` build target and Webinizer will prompt you with the recommended build steps
     for the project.

   - Click `YES` to accept the recommendation.

   - Click `BUILD ->` in the lower right corner or `Build` in the top navigation panel to enter the
     `Build` page.

5. **`Build page`**

   - Click the `BUILD` button to trigger the build and some recipes will show in several rounds of
     build.

   - `Recipe for C++ exception` - Click the `APPLY RECIPE` button and another build will be
     triggered.

     > Note. _As the usage of C++ exception is detected in the native code, we can enable the Wasm
     > exception handling for it as well._

   - `Recipe for checking project dependent packages`- Click the `APPLY RECIPE` button to accept the
     recipe as well.

     > Note. _We detected dependent packages required for the project and would like to use
     > Emscripten specific build options for them to use the ported Wasm versions. We may modify the
     > CMakeLists.txt file to remove unnecessary dependent packages statements._

   - `Recipe for main loop issue` - Click `Edit` in the top navigation panel and we’ll be directed
     to the `Editor` page.

     > Note. _We are building an application that is running on the main thread, which is using an
     > infinite loop to render animations and thread-blocking. As the recipe suggested, we should
     > modify our source code with specific API provided by Emscripten._

6. **`Editor page`**

   - Select the file `src -> main.cpp` from the `Project Explorer` sidebar and modify the code as
     below based on the suggestion. Note that the code changes might vary among different projects.

   ```diff
     // src/main.cpp
     #include <iostream>
     #include "controller.h"
     #include "game.h"
     #include "renderer.h"
   + #include <emscripten.h>

   - int main() {
     constexpr std::size_t kFramesPerSecond{60};
     constexpr std::size_t kMsPerFrame{1000 / kFramesPerSecond};
     constexpr std::size_t kScreenWidth{640};
     constexpr std::size_t kScreenHeight{640};
     constexpr std::size_t kGridWidth{32};
     constexpr std::size_t kGridHeight{32};

     Renderer renderer(kScreenWidth, kScreenHeight, kGridWidth,  kGridHeight);
     Controller controller;
   -   Game game(kGridWidth, kGridHeight);
   -   game.Run(controller, renderer, kMsPerFrame);
   -   std::cout << "Game has terminated successfully!\n";
   -   std::cout << "Score: " << game.GetScore() << "\n";
   -   std::cout << "Size: " << game.GetSize() << "\n";

   + Game *game;

   + void mainLoopWrapper(){
   +   game->Run(controller, renderer, kMsPerFrame);
   + }

   + int main() {
   +   Game gameIns(kGridWidth, kGridHeight);
   +   game = &gameIns;
   +   emscripten_set_main_loop(mainLoopWrapper, 0, 1);
       return 0;
     }
   ```

   ```diff
     // src/game.cpp
   + #include <emscripten.h>

     void Game::Run(Controller const &controller, Renderer &renderer,
                  std::size_t target_frame_duration) {
        Uint32 title_timestamp = SDL_GetTicks();
        Uint32 frame_start;
        Uint32 frame_end;
        Uint32 frame_duration;
        int frame_count = 0;
        bool running = true;
        int frame_count = 0;
        bool running = true;
   -    while (running) {
          ...
   -    }
        ...
     }

     void Game::Update() {
   -   if (!snake.alive) return;
   +   if (!snake.alive){
   +       // Use JS alert function to display the Score and Size when snake is died.
   +       EM_ASM({
   +           var message = 'Game Over...\nYour Score: ' +  $0 + '\nSize: '+ +$1;
   +           alert(message);
   +       }, score, snake.size);
   +       emscripten_cancel_main_loop();
   +       return;
   +   }
       ...
     }
   ```

- Click the `SAVE` button to save the changes.

- Click `Build` in the top navigation panel to route us back to the `Build` page.

7. **`Build page`** - Click the `BUILD` button to trigger the build again.

After a while, it will show `Build successfully!` on the page.

## How to run the demo

- Below are the generated files that are required to run the demo:

  - Snake.js
  - Snake.wasm
  - Snake.html

- Set up the server

  Run the script to copy all the files required and start the server.

  ```sh
  ./run.sh
  ```

- Run in the browser

  ```
  http://localhost:8080
  ```

- Try it!
  - Directions - Arrow keys `up, down, left, right`
