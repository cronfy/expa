# Размещение кода в списках markdown

Спасибо [этому автору](https://gist.github.com/clintel/1155906).

## Рабочий пример

1. This is a numbered list.
1. I'm going to include a fenced code block as part of this bullet:

    ```
    Code
    More Code
    ```

1. We can put fenced code blocks inside nested bullets, too.
   1. Like this:

        ```c
        printf("Hello, World!");
        ```

   2. The key is to indent your fenced block by **(4 * bullet_indent_level)** spaces.
   3. Also need to put a separating newline above and below the fenced block.

## Впечатления

Ну и ну. Весь код нужно весь сдвигать вправо и вырванивать под апострофами! Никогда бы не 
догадался.

