# Tutorial for building and running Tetris WASM demo with Webinizer

## How to build Tetris with Webinizer

1. **`Main page`** - Click `Get Started` in Webinizer main page to enter the project list page.

2. **`Get started page`** - Click the `SELECT` button of the Tetris project to enter the
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
     > Emscripten specific build options for them to use the ported Wasm versions._

   - `Recipe for main loop issue` - Click `Edit` in the top navigation panel and we’ll be directed
     to the `Editor` page.

     > Note. _We are building an application that is running on the main thread, which is using an
     > infinite loop to render animations and thread-blocking. As the recipe suggested, we should
     > modify our source code with specific API provided by Emscripten._

6. **`Editor page`**

   - Select the file `src -> main.cpp` from the `Project Explorer` sidebar and modify the code as
     below based on the suggestion. Note that the code changes might vary among different projects.

   ```cpp
    // src/main.cpp
    #include "game.h"
    #include <emscripten.h>

    int main() {
      emscripten_set_main_loop(
        []() {
            static Game game;
            game.loop();
        }, 0, 1);
      return 0;
    }
   ```

   - Click the `SAVE` button to save the changes.

   - Click `Build` in the top navigation panel to route us back to the `Build` page.

7. **`Build page`** - Click the `BUILD` button to trigger the build again.

After a while, it will show `Build successfully!` on the page.

## How to run the demo

- Below are the generated files that are required to run the demo:

  - Tetris.js
  - Tetris.wasm
  - Tetris.data

- Set up the server

  Run the script to copy all the files required and start the server.

  ```sh
  ./run.sh
  ```

  > Note. If you are generating the target with different name rather than `Tetris`, please also
  > modify below files as well.

  - `index.html`, the imported script `src`

    ```html
    <!-- line 34 -->
    <script type="application/javascript" src="Tetris.js"></script>
    ```

  - `run.sh`, the copy file names.

    ```sh
    # line 7
    cp ../../native_projects/tetris/Tetris.* .
    ```

- Run in the browser

  ```
  http://localhost:8080
  ```

- Try it!
  - Directions - Arrow keys `down, left, right`
  - Change the shape - Arrow Keys `Up`
