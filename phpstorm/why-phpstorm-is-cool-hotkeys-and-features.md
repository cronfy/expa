# Удобные моменты PHPStorm

## Буфер обмена с историей

 * Оказывается, он есть! И работает по Ctrl-Shift-V. Очень удобно использовать для вставки того, что было в буфере
   некоторое время назад. Удобно набрать несколько значений, а потом ходить и вставлять их в нужные места (при 
   веерном копипасте).
 * Оказывается, Ctrl-Shift-V работает не только в редакторе, а еще и в системных диалогах, например, в диалоге копирования
   файла! Можно скопировать имя нового файла в буфер, потом Ctrl-C, Ctrl-V для копирования файла и Ctrl-Shift-V для
   вставки имени файла!
   
## Навигация 

 * По Ctrl-b можно перейти к определению метода, или к использованию метода, если нажимать Ctrl-b на определении.
 * Ctrl-Shift-Backspace переходит к последнему месту, где что-то редактировал.
 * Shift-Alt-влево перемещает на предыдущее место в редакторе, где ты был! Это просто огонь. Shift-Alt-вправо перемещает 
   обратно. Возможно, именно такие кнопки придется настроить вручную (Settings | Keymap -> Main menu -> Navigate -> Back, Forward) 
   и отключить аналогичные горячие клавиши ОС (у меня конфликтовало с Cinnamon). Но можно пользоваться и из меню 
   Navigate -> Back.
 * Очень удобно, что по Ctrl-Shift-N можно искать не только файлы, но и папки - добавив в конце слеш `/`.
 * Очень удобно, что по Ctrl-Shift-N можно вводить не полные названия, например:
   * `ap/cons/expo` прекрасно находит `apps/console/controllers/ExportController.php`,
   *  `phps/read` показывает `somewhere/deep/in/the/hierarchy/phpstorm/readme.md` 
   * и т. д.
 * А еще по Ctrl-Shift-N можно укзывать маску! `some*not*member` найдет файл `somethingthatidonotremember.php`! 
 * Когда нажимаешь на элемент, выводящий список веток (например, справа внизу, или в панели Git на вкладке Log элемент Branch, 
   в общем, везде, где есть список веток), можно не искать глазами нужную ветку, чтобы тыкнуть мышкой. Вместо этого можно
   сразу начать вводить название ветки на клавиатуре, и шторм подскажет. То есть, не нужно даже ставить курсор ни на какое
   поле поиска - просто кликнул - только-только выпало какое-то меню - и уже можно набирать название. Очень удобно,
   особенно когда веток много.
 * Аналогично при коммите, когда кликаешь на часики и ищешь среди истории коммитов. Просто нажал на часики, начал набирать
   что ты там хотел найти - шторм отфильтрует.
   
## Редактирование

 * Ctrl-Shift-U переключает регистр у выделенного текста.
 * Ctrl-Shift-J присоединяет нижестоящую строку, прямо как в vim!
 * Мультикурсоры! Зажимаем Ctrl-Alt, держим и кликаем мышкой в редакторе - курсоры ставятся в нескольких местах сразу.
   При наборе текста или при передвижении стрелочками, даже при выделении текста - все действия производятся во всех 
   местах. Home/End тоже работают. Очень круто. Сброс курсоров кнопкой Esc или обычным кликом в любом месте.
 * Ctrl-C на файл в дереве Project и Ctrl-V в редакторе вставляет имя файла, удобно.
 * Ctrl-Shift-C в редакторе копирует полный путь к файлу в буфер (удобно скопировать путь, а после указать путь к файлу
   для какой-нибудь консольной тулзы, например).
 * Ctrl-- (Ctrl-минус) сворачивает текущий блок кода. Удобнее, чем слева целиться в стрелочки. Особенно в блоках `if () {} else {}`
 * Ctrl-Alt-R (возможно по умолчанию другая комбинация) - реформат кода. Помогает и для JS, и для PHP, и для XML и т. д. переформатировать 
   код. Например, однострочный XML разворачивает на строки. Выравнивает массивы. Есть настройки в Settings, какой код как форматировать.
 * Ctrl-Alt-Shift-Insert - создаёт новый Scratch-файл. Удобно создать, вставить код из буфера (например, xml), отформатировать, 
   поизучать. Или набросать временные заметки, или SQL-запрос, или PHP/JS-код и т. д. Причем если даже эти файлы закрыть в редакторе, 
   PHPStorm их помнит (Project View -> Scratches and Consoles).
 * Режим блочного выделения/редактирования по Alt-Shift-Insert жутко помогает, когда нужно ввести ' * ' сразу на несколько строк или удалить общий префикс. Главное запомнить, как выйти это этого режима (тоже Alt-Shift-Insert)
 * Мультикурсоры по Ctrl-Alt-LeftClick тоже помогают делать одинаковые изменения в разных местах. Выход по Esc.
 * Settings | Editor | General | Soft-wrap these files - очень удобно настроить, чтобы для _некоторых_ файлов (например, markdown) длинные строки визуально в редакторе переносились разбивались на строки (без реального разбиения - поэтому soft wrap). Удобно - в markdown переносится, в js не переносится. 
 * Ctrl-Alt-Shift-C, когда курсор на методе класса, копирует \Fully\Qualified\Class\Name::methodName в буфер обмена.
Очень удобно, чтобы сослаться где-нибудь в документации/комментарии/чатике на какой-либо метод.
   
## Печали

К сожалению...

 * ... не всегда корректно работает подсветка неиспользуемых свойств/методов - бывают и false positive и false negative
   * https://intellij-support.jetbrains.com/hc/en-us/requests/3242018
   * https://youtrack.jetbrains.com/issue/WI-42733
   * https://youtrack.jetbrains.com/issue/WI-48012#focus=Comments-27-3642430.0-0
   
## Советуют изучить

> Я бы настоятельно рекомендовал перечитать вот эти два блока документации, что может существенно уменьшить объем написанного руками кода: Auto-Completing Code и Generating Code. Практически все стандартные конструкции языка можно сгенерировать одним нажатием.
> https://habr.com/ru/post/175867/

 * https://www.jetbrains.com/help/idea/auto-completing-code.html
 * https://www.jetbrains.com/help/idea/generating-code.html